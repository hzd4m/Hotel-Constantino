require "csv"

class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    if request.format.csv?
      export_hotels_csv and return
    end

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
  end

  def handle_guest_flow
    @hospede = current_user.hospede_record
    if @hospede.present?
      redirect_to guest_reservas_path and return
    else
      flash.now[:alert] = "Não encontramos seu cadastro de hóspede. Entre em contato com a recepção."
    end
  end

  def export_hotels_csv
    unless current_user&.admin?
      head :unauthorized and return
    end

    if filters_blank?
      redirect_to dashboard_path, alert: "Selecione pelo menos um filtro para exportar o CSV." and return
    end

    hotels_scope = filtered_hotels_for_export

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ["ID", "Nome", "Cidade", "Categoria"]
      hotels_scope.find_each do |hotel|
        csv << [hotel.id, hotel.nome, hotel.cidade, hotel.categoria]
      end
    end

    send_data csv_data,
              filename: "hotels-#{Time.current.strftime('%Y%m%d-%H%M')}.csv",
              type: "text/csv"
  end

  def filters_blank?
    params[:city].blank? && params[:category].blank?
  end

  def filtered_hotels_for_export
    scope = Hotel.order(:nome)
    scope = scope.where(cidade: params[:city]) if params[:city].present?
    scope = scope.where(categoria: params[:category]) if params[:category].present?
    scope
  end
end
