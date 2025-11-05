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
    @hotel_filter_cities = Hotel.where.not(cidade: [nil, ""]).distinct.order(:cidade).pluck(:cidade)
    @hotel_filter_categories = Hotel.where.not(categoria: [nil, ""]).distinct.order(:categoria).pluck(:categoria)
    @reserva_statuses = Reserva.distinct.order(:status).pluck(:status).reject(&:blank?)
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
