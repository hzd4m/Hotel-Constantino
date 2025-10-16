class HospedesController < ApplicationController
    before_action :authenticate_user!

  def index
    @hospedes = Hospede.all
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
