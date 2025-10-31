class HotelsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_hotel, only: [:show, :edit, :update, :destroy]

  def index
    @hotels = Hotel.all
    
    # filtros
    @hotels = @hotels.where("UPPER(nome) LIKE ?", "%#{params[:nome].upcase}%") if params[:nome].present?
    @hotels = @hotels.where("UPPER(cidade) LIKE ?", "%#{params[:cidade].upcase}%") if params[:cidade].present?
    @hotels = @hotels.where("UPPER(categoria) LIKE ?", "%#{params[:categoria].upcase}%") if params[:categoria].present?

    # ordenação e paginação
    @hotels = @hotels.order(:nome).page(params[:page]).per(10)
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
