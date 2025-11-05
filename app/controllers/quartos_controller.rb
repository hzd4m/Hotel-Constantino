class QuartosController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  before_action :set_hotel
  before_action :set_quarto, only: [:show, :edit, :update, :destroy]
  before_action :load_room_type_options, only: [:new, :create, :edit, :update]

  def index
    @quartos = @hotel.quartos.includes(:room_type).order(:andar, :numero).page(params[:page]).per(15)
  end

  def show; end

  def new
    @quarto = @hotel.quartos.new
  end

  def create
    @quarto = @hotel.quartos.new(quarto_params)
    if @quarto.save
      redirect_to hotel_quarto_path(@hotel, @quarto), notice: "Quarto cadastrado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @quarto.update(quarto_params)
      redirect_to hotel_quarto_path(@hotel, @quarto), notice: "Quarto atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @quarto.destroy
      redirect_to hotel_quartos_path(@hotel), notice: "Quarto removido."
    else
      redirect_to hotel_quarto_path(@hotel, @quarto), alert: "Não foi possível remover o quarto."
    end
  end

  private

  def set_hotel
    @hotel = Hotel.find(params[:hotel_id])
  end

  def set_quarto
    @quarto = @hotel.quartos.find(params[:id])
  end

  def quarto_params
    params.require(:quarto).permit(:numero, :andar, :capacidade, :descricao, :status, :price_cents, :room_type_id)
  end

  def load_room_type_options
    @room_types = @hotel.room_types.order(:nome)
  end
end
