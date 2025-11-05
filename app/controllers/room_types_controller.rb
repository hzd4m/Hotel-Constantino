class RoomTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  before_action :set_hotel
  before_action :set_room_type, only: [:show, :edit, :update, :destroy]

  def index
    @room_types = @hotel.room_types.order(:nome).page(params[:page]).per(15)
  end

  def show; end

  def new
    @room_type = @hotel.room_types.new
  end

  def create
    @room_type = @hotel.room_types.new(room_type_params)
    if @room_type.save
      redirect_to hotel_room_type_path(@hotel, @room_type), notice: "Tipo de quarto criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @room_type.update(room_type_params)
      redirect_to hotel_room_type_path(@hotel, @room_type), notice: "Tipo de quarto atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @room_type.destroy
      redirect_to hotel_room_types_path(@hotel), notice: "Tipo de quarto removido."
    else
      redirect_to hotel_room_type_path(@hotel, @room_type), alert: "Não foi possível remover o tipo de quarto."
    end
  end

  private

  def set_hotel
    @hotel = Hotel.find(params[:hotel_id])
  end

  def set_room_type
    @room_type = @hotel.room_types.find(params[:id])
  end

  def room_type_params
    params.require(:room_type).permit(:nome, :descricao, :price_cents, amenities: [])
  end
end
