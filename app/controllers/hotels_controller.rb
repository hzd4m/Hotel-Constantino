require "csv"

class HotelsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_hotel, only: [:show, :edit, :update, :destroy]
  before_action :require_admin!, only: [:export]

  def index
    @filters = sanitized_filters
    @hotels = filtered_hotels.order(:nome).page(params[:page]).per(10)
  end

  def export
    hotels_scope = export_scope

    respond_to do |format|
      format.csv do
        send_data hotels_csv(hotels_scope),
                  filename: "hotels-#{Time.current.strftime('%Y%m%d-%H%M')}.csv",
                  type: "text/csv"
      end

      format.pdf do
        pdf = Pdf::HotelsReport.new(hotels_scope).render
        send_data pdf,
                  filename: "relatorio-hotels-#{Time.current.strftime('%Y%m%d-%H%M')}.pdf",
                  type: "application/pdf",
                  disposition: :attachment
      end

      format.any do
        redirect_to hotels_path, alert: "Formato de exportação não suportado."
      end
    end
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

  def sanitized_filters(source = params)
    {
      nome: source[:nome].to_s.strip,
      cidade: source[:cidade].to_s.strip,
      categoria: source[:categoria].to_s.strip
    }
  end

  def filtered_hotels(scope = Hotel.all)
    filters = sanitized_filters
    arel_table = Hotel.arel_table

    scope = scope.where(arel_table[:nome].matches("%#{filters[:nome]}%")) if filters[:nome].present?
    scope = scope.where(arel_table[:cidade].matches("%#{filters[:cidade]}%")) if filters[:cidade].present?
    scope = scope.where(arel_table[:categoria].matches("%#{filters[:categoria]}%")) if filters[:categoria].present?
    scope
  end

  def export_scope
    scope = Hotel.order(:nome)
    return scope if params[:export_scope] == "all"

    filtered_hotels(scope)
  end

  def hotels_csv(scope)
    CSV.generate(headers: true) do |csv|
      csv << ["ID", "Nome", "Cidade", "Categoria", "Telefone"]
      scope.each do |hotel|
        csv << [hotel.id, hotel.nome, hotel.cidade, hotel.categoria, hotel.telefone]
      end
    end
  end
end
