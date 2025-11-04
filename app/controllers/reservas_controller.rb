class ReservasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reserva, only: %i[show edit update destroy]

  def index
    @reservas = filtered_reservas.page(params[:page]).per(10)
  end

  def export_pdf
    unless current_user.admin?
      redirect_to reservas_path, alert: "Apenas administradores podem gerar o PDF." and return
    end

    reservas = filtered_reservas
    pdf = Pdf::ReservasReport.new(reservas).render

  send_data pdf,
        filename: "relatorio-reservas-#{Time.current.strftime('%Y%m%d-%H%M')}.pdf",
        type: "application/pdf",
        disposition: :attachment
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

  def filtered_reservas
    scope = Reserva.includes(:hotel, :hospede)
    scope = scope.joins(:hotel).where("UPPER(hotels.nome) LIKE ?", "%#{params[:hotel_nome].upcase}%") if params[:hotel_nome].present?
    scope = scope.joins(:hospede).where("UPPER(hospedes.nome) LIKE ?", "%#{params[:hospede_nome].upcase}%") if params[:hospede_nome].present?
    scope = scope.where("reservas.data_checkin >= ?", params[:data_checkin]) if params[:data_checkin].present?
    scope = scope.where("reservas.data_checkout <= ?", params[:data_checkout]) if params[:data_checkout].present?
    scope = scope.where(status: params[:status]) if params[:status].present?
    scope.order(:data_checkin)
  end

  def set_reserva
    @reserva = Reserva.find(params[:id])
  end

  def reserva_params
    params.require(:reserva).permit(:data_checkin, :data_checkout, :status, :valor_total, :hotel_id, :hospede_id)
  end
end
