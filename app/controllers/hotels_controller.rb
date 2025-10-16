class HotelsController < ApplicationController
    before_action :authenticate_user!

  def index
    @hotels = Hotel.all
  end

  def show 
  end 

  def new 
    @hotel = Hotel.new
  end 

  def create 
    @hotel = Hotel.new(hotel_params)
    if @hotel.save
        redirect_to @hotel, notice: 'Hotel criado com sucesso.'
    else 
        render :new 
    end
  end 

  def edit 
  end 

  def update 
    if @hotel.update(hotel_params)
        redirect_to @hotel, notice: 'Hotel atualizado com sucesso.'
    else 
        render :new 
    end 
  end 
  
  def destroy 
    @hotel.destroy 
    redirect_to hotels_path, notice: 'Hotel excluído com sucesso.'
  end 

  private 

  def set_hotel 
    @hotel = Hotel.find(params[:id])
  end 

  def hotel_params 
    params.require(:hotel).permit(:nome, :cidade, :endereco, :telefone, :categoria)
  end 
end
