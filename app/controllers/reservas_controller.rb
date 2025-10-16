class ReservasController < ApplicationController
    before_action :authenticate_user! 

  def index
    @reservas = Reserva.all
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
