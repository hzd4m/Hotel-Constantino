class HospedesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_hospede, only: [:show, :edit, :update, :destroy]

  def index
    @hospedes = Hospede.all
    
    # filtros
    @hospedes = @hospedes.where("UPPER(nome) LIKE ?", "%#{params[:nome].upcase}%") if params[:nome].present?
    @hospedes = @hospedes.where("UPPER(documento) LIKE ?", "%#{params[:documento].upcase}%") if params[:documento].present?
    @hospedes = @hospedes.where("UPPER(email) LIKE ?", "%#{params[:email].upcase}%") if params[:email].present?

    # ordenação e paginação
    @hospedes = @hospedes.order(:nome).page(params[:page]).per(10)
  end

  def show 
  end 

  def new 
    @hospede = Hospede.new
  end 

  def create 
    @hospede = Hospede.new(hospede_params)
    if @hospede.save
        redirect_to @hospede, notice: 'Hóspede criado com sucesso.'
    else 
        render :new 
    end 
  end 
  
  
  def edit 
  end 

  def update 
    if @hospede.update(hospede_params) 
        redirect_to @hospede, notice: 'Hóspede atualizado com sucesso.' 
    else 
        render :new 
    end 
end 

   def destroy 
    @hospede.destroy 
    redirect_to hospedes_path, notice: 'Hóspede excluído com sucesso.'
   end 

   private 
     def set_hospede 
        @hospede = Hospede.find(params[:id])
     end 

     def hospede_params 
        params.require(:hospede).permit(:nome, :documento, :email, :telefone)
     end 

     
end
