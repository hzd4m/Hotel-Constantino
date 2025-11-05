require "csv"

class ReservasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reserva, only: %i[show edit update destroy confirmar check_in check_out create_consumption update_consumption]
  before_action :require_admin!, only: [:export, :incompletas, :confirmar, :check_in, :check_out, :create_consumption, :update_consumption, :calendar]
  before_action :load_form_dependencies, only: [:new, :create, :edit, :update]
  before_action :load_show_dependencies, only: [:show, :edit, :update]

  def index
    @filters = reserva_filters
    @reservas = filtered_reservas.page(params[:page]).per(10)
  end

  def incompletas
    @reservas_sem_verificacao = Reserva.awaiting_phone_verification.includes(:hotel, :hospede).order(created_at: :desc)
    @reservas_prontas = Reserva.ready_for_confirmation.includes(:hotel, :hospede).order(created_at: :desc)
  end

  def export
    reservas_scope = filtered_reservas(export_all: params[:export_scope] == "all")

    respond_to do |format|
      format.csv do
        send_data reservas_csv(reservas_scope),
                  filename: "reservas-#{Time.current.strftime('%Y%m%d-%H%M')}.csv",
                  type: "text/csv"
      end

      format.pdf do
        pdf = Pdf::ReservasReport.new(reservas_scope).render
        send_data pdf,
                  filename: "relatorio-reservas-#{Time.current.strftime('%Y%m%d-%H%M')}.pdf",
                  type: "application/pdf",
                  disposition: :attachment
      end

      format.any do
        redirect_to reservas_path, alert: "Formato de exportação não suportado."
      end
    end
  end

  def show; end

  def new
    @reserva = Reserva.new
  end

  def create
    @reserva = Reserva.new(reserva_params)
    if @reserva.save
      redirect_to @reserva, notice: "Reserva criada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @reserva.update(reserva_params)
      redirect_to @reserva, notice: "Reserva atualizada com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @reserva.destroy
    redirect_to reservas_path, notice: "Reserva excluída com sucesso."
  end

  def confirmar
    if @reserva.mark_confirmed_by!(current_user)
      redirect_back fallback_location: incompletas_reservas_path, notice: "Reserva confirmada com sucesso."
    else
      message = if @reserva.hospede&.phone_verified?
                  "Não foi possível confirmar a reserva."
                else
                  "O telefone do hóspede ainda não foi verificado. Confirme antes de finalizar."
                end
      redirect_back fallback_location: incompletas_reservas_path, alert: message
    end
  end

  def check_in
    if @reserva.mark_checked_in!(current_user)
      redirect_back fallback_location: reserva_path(@reserva), notice: "Check-in registrado com sucesso."
    else
      alert_message = if @reserva.hospede&.phone_verified?
                        "Não foi possível registrar o check-in."
                      else
                        "O telefone do hóspede ainda não foi verificado."
                      end
      redirect_back fallback_location: reserva_path(@reserva), alert: alert_message
    end
  end

  def check_out
    if @reserva.mark_checked_out!(current_user)
      redirect_back fallback_location: reserva_path(@reserva), notice: "Check-out registrado com sucesso."
    else
      alert_message = if @reserva.checked_in?
                        "Não foi possível registrar o check-out."
                      else
                        "Marque o check-in antes de finalizar a estadia."
                      end
      redirect_back fallback_location: reserva_path(@reserva), alert: alert_message
    end
  end

  def create_consumption
    @consumption = @reserva.consumptions.new(consumption_params)
    @consumption.requested_by ||= "staff"

    if @consumption.save
      redirect_back fallback_location: reserva_path(@reserva), notice: "Consumo registrado com sucesso."
    else
      @new_consumption = @consumption
      load_show_dependencies
      flash.now[:alert] = "Não foi possível registrar o consumo."
      render :show, status: :unprocessable_entity
    end
  end

  def update_consumption
    @consumption = @reserva.consumptions.find(params[:consumption_id])

    if @consumption.update(consumption_update_params)
      redirect_back fallback_location: reserva_path(@reserva), notice: "Consumo atualizado com sucesso."
    else
      redirect_back fallback_location: reserva_path(@reserva), alert: "Não foi possível atualizar o consumo."
    end
  end

  def calendar
    @hotels = Hotel.order(:nome).to_a
    @view_mode = permitted_calendar_view(params[:view])
    @reference_date = parse_reference_date(params[:start_date])
    @reference_date = @reference_date.beginning_of_month if @view_mode == "monthly"
    @weekday_labels = I18n.t("date.abbr_day_names").rotate(1)

    @selected_hotel = resolve_selected_hotel(@hotels, params[:hotel_id])

    assign_period_boundaries

    @reservations_by_day = Hash.new { |hash, key| hash[key] = [] }
    reservations = if @selected_hotel.present?
                     @selected_hotel.reservas
                                    .where("data_checkin <= ? AND data_checkout >= ?", @period_end, @period_start)
                                    .includes(:hospede)
                   else
                     Reserva.none
                   end

    reservations = reservations.to_a
    reservations.each do |reserva|
      stay_start = [reserva.data_checkin.to_date, @period_start].max
      stay_end = [reserva.data_checkout.to_date - 1, @period_end].min
      next if stay_start > stay_end

      current_day = stay_start
      while current_day <= stay_end
        @reservations_by_day[current_day] << reserva
        current_day += 1
      end
    end

    @calendar_weeks = build_calendar_weeks
    @reservations_count = reservations.size
    @total_days = (@period_end - @period_start + 1).to_i
    total_occupancy = @reservations_by_day.values.sum(&:size)
    @average_daily_occupancy = @total_days.positive? ? (total_occupancy.to_f / @total_days).round(1) : 0
    @peak_occupancy = @reservations_by_day.values.map(&:size).max.to_i

    @current_start_date_param = (@view_mode == "weekly" ? @period_start : @reference_date).iso8601
    @prev_params = navigation_params_for(-1)
    @next_params = navigation_params_for(1)
  end

  private

  def permitted_calendar_view(candidate)
    value = candidate.to_s
    %w[weekly monthly].include?(value) ? value : "monthly"
  end

  def parse_reference_date(raw_value)
    return Date.current if raw_value.blank?

    Date.parse(raw_value.to_s)
  rescue ArgumentError
    Date.current
  end

  def resolve_selected_hotel(hotels, hotel_id_param)
    return nil if hotels.blank?

    return hotels.first if hotel_id_param.blank?

    hotels.detect { |hotel| hotel.id == hotel_id_param.to_i } || hotels.first
  end

  def assign_period_boundaries
    if @view_mode == "weekly"
      @period_start = @reference_date.beginning_of_week(:monday)
      @period_end = @period_start + 6
  @period_label = "#{I18n.l(@period_start, format: :short)} - #{I18n.l(@period_end, format: :short)}"
    else
      @period_start = @reference_date.beginning_of_month.beginning_of_week(:monday)
      @period_end = @reference_date.end_of_month.end_of_week(:monday)
      @period_label = I18n.l(@reference_date, format: :calendar_month)
    end
  end

  def build_calendar_weeks
    return [] if @period_start.blank? || @period_end.blank?

    weeks = []
    week_start = @period_start
    while week_start <= @period_end
      week = []
      7.times do |offset|
        day = week_start + offset
        reservations = @reservations_by_day.fetch(day, [])
        week << {
          date: day,
          primary_period: primary_period_day?(day),
          reservations: reservations
        }
      end
      weeks << week
      week_start += 7
    end
    weeks
  end

  def primary_period_day?(date)
    if @view_mode == "weekly"
      date.between?(@period_start, @period_end)
    else
      date.month == @reference_date.month && date.year == @reference_date.year
    end
  end

  def navigation_params_for(direction)
    target_date = if @view_mode == "weekly"
                    @period_start + (direction * 7)
                  else
                    @reference_date.advance(months: direction)
                  end

    params = { view: @view_mode, start_date: target_date.iso8601 }
    params[:hotel_id] = @selected_hotel.id if @selected_hotel.present?
    params
  end

  def filtered_reservas(export_all: false)
    scope = Reserva.includes(:hotel, :hospede).order(:data_checkin)
    return scope if export_all

    filters = reserva_filters
    scope = scope.joins(:hotel).where("UPPER(hotels.nome) LIKE ?", "%#{filters[:hotel_nome].upcase}%") if filters[:hotel_nome].present?
    scope = scope.joins(:hospede).where("UPPER(hospedes.nome) LIKE ?", "%#{filters[:hospede_nome].upcase}%") if filters[:hospede_nome].present?
    scope = scope.where("reservas.data_checkin >= ?", filters[:data_checkin]) if filters[:data_checkin].present?
    scope = scope.where("reservas.data_checkout <= ?", filters[:data_checkout]) if filters[:data_checkout].present?
    scope = scope.where(status: filters[:status]) if filters[:status].present?
    scope
  end

  def set_reserva
    @reserva = Reserva.find(params[:id])
  end

  def load_show_dependencies
    return unless @reserva.present?

    @consumptions = @reserva.consumptions.order(requested_at: :desc)
    @timeline_entries = @reserva.timeline_entries
    @new_consumption ||= @reserva.consumptions.build(requested_by: "staff")
  end

  def reserva_params
    params.require(:reserva).permit(
      :data_checkin,
      :data_checkout,
      :status,
      :valor_total,
      :hotel_id,
      :hospede_id,
      quarto_ids: []
    )
  end

  def consumption_params
    params.require(:consumption).permit(:title, :notes, :status, :amount, :requested_by)
  end

  def consumption_update_params
    params.require(:consumption).permit(:status, :notes, :amount)
  end

  def reserva_filters(source = params)
    {
      hospede_nome: source[:hospede_nome].to_s.strip,
      hotel_nome: source[:hotel_nome].to_s.strip,
      data_checkin: source[:data_checkin].presence,
      data_checkout: source[:data_checkout].presence,
      status: source[:status].to_s.strip.presence
    }
  end

  def reservas_csv(scope)
    CSV.generate(headers: true) do |csv|
      csv << ["ID", "Hóspede", "Hotel", "Check-in", "Check-out", "Status", "Valor total"]
      scope.each do |reserva|
        csv << [
          reserva.id,
          reserva.hospede&.nome,
          reserva.hotel&.nome,
          reserva.data_checkin.present? ? I18n.l(reserva.data_checkin) : nil,
          reserva.data_checkout.present? ? I18n.l(reserva.data_checkout) : nil,
          reserva.status,
          reserva.valor_total.present? ? reserva.valor_total.to_f : nil
        ]
      end
    end
  end

  def load_form_dependencies
    @hospedes_options = Hospede.order(:nome)
    @hotels_options = Hotel.order(:nome)

    hotel_id_param = params.dig(:reserva, :hotel_id).presence || @reserva&.hotel_id
    @selected_hotel = @hotels_options.find_by(id: hotel_id_param) if hotel_id_param.present?

    assigned_quartos = @reserva&.quartos&.includes(:hotel, :room_type)&.to_a || []
    scoped_quartos = if @selected_hotel.present?
                       @selected_hotel.quartos.includes(:hotel, :room_type).order(:andar, :numero)
                     else
                       Quarto.none
                     end

    @quartos_options = (scoped_quartos.to_a + assigned_quartos).uniq { |quarto| quarto.id }
  end
end
