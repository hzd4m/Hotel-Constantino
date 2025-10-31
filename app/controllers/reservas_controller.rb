class ReservasController < ApplicationController
    before_action :authenticate_user! 
    before_action :set_reserva, only: [:show, :edit, :update, :destroy]

  def index
    @reservas = Reserva.includes(:hotel, :hospede).all
    
    # Filtros
    if params[:hotel_nome].present?
      @reservas = @reservas.joins(:hotel)
                          .where("UPPER(hotels.nome) LIKE ?", "%#{params[:hotel_nome].upcase}%")
    end

    if params[:hospede_nome].present?
      @reservas = @reservas.joins(:hospede)
                          .where("UPPER(hospedes.nome) LIKE ?", "%#{params[:hospede_nome].upcase}%")
    end
    @reservas = @reservas.where("data_checkin >= ?", params[:data_checkin]) if params[:data_checkin].present?
    @reservas = @reservas.where("data_checkout <= ?", params[:data_checkout]) if params[:data_checkout].present?
    @reservas = @reservas.where(status: params[:status]) if params[:status].present?

    # ordenação e paginação
    @reservas = @reservas.order(:data_checkin).page(params[:page]).per(10)
  end


  def show
  end 

  def new 
    @reserva = Reserva.new 
  end 

  def create
    @reserva = Reserva.new(reserva_params)
    if @reserva.save 
        redirect_to @reserva, notice: 'Reserva criada com sucesso.'
    else 
        render :new 
    end
  end 
  
  def edit 
  end 

  def update 
    if @reserva.update(reserva_params)
        redirect_to @reserva, notice: 'Reserva atualizada com sucesso.'
    else 
        render :new 
    end 
end 

   def destroy 
    @reserva.destroy
    redirect_to reservas_path, notice: 'Reserva excluída com sucesso.'
   end 

   private 

   def set_reserva
    @reserva = Reserva.find(params[:id])
   end 

   def reserva_params 
    params.require(:reserva).permit(:data_checkin, :data_checkout, :status, :valor_total, :hotel_id, :hospede_id) 
   end 
 
end
