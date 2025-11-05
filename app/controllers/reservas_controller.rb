require "csv"

class ReservasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reserva, only: %i[show edit update destroy]
  before_action :require_admin!, only: [:export]
  before_action :load_form_dependencies, only: [:new, :create, :edit, :update]

  def index
    @filters = reserva_filters
    @reservas = filtered_reservas.page(params[:page]).per(10)
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

  private

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

  def reserva_params
    params.require(:reserva).permit(:data_checkin, :data_checkout, :status, :valor_total, :hotel_id, :hospede_id)
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
  end
end
