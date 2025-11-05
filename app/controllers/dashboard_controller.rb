class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    render_html_dashboard
  end

  private

  def render_html_dashboard
    if current_user.admin?
      load_admin_metrics
    else
      handle_guest_flow
    end
  end

  def load_admin_metrics
    @hotels_count = Hotel.count
    @reservas_count = Reserva.count
    @hospedes_count = Hospede.count
    @latest_reservas = Reserva.includes(:hotel, :hospede).order(created_at: :desc).limit(5)
    @reservas_sem_verificacao_count = Reserva.awaiting_phone_verification.count
    @reservas_prontas_confirmacao_count = Reserva.ready_for_confirmation.count
    @reservas_sem_verificacao = Reserva.awaiting_phone_verification.includes(:hotel, :hospede).order(created_at: :desc).limit(5)
    @reservas_prontas_confirmacao = Reserva.ready_for_confirmation.includes(:hotel, :hospede).order(created_at: :desc).limit(5)
    @awaiting_operations = Reserva.awaiting_operations.includes(:hotel, :hospede).order(data_checkin: :asc).limit(5)
    @active_stays = Reserva.checked_in.includes(:hotel, :hospede).order(check_in_at: :desc).limit(5)
    @operations_timeline = ReservationEvent.includes(reserva: [:hotel, :hospede]).order(created_at: :desc).limit(15)
    @hotel_filter_cities = Hotel.where.not(cidade: [nil, ""]).distinct.order(:cidade).pluck(:cidade)
    @hotel_filter_categories = Hotel.where.not(categoria: [nil, ""]).distinct.order(:categoria).pluck(:categoria)
    @reserva_statuses = Reserva.statuses.keys
  end

  def handle_guest_flow
    @hospede = current_user.hospede_record
    if @hospede.present?
      redirect_to guest_reservas_path and return
    else
      flash.now[:alert] = "Não encontramos seu cadastro de hóspede. Entre em contato com a recepção."
    end
  end
end
