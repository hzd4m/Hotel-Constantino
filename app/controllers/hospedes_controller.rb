require "csv"

class HospedesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_hospede, only: [:show, :edit, :update, :destroy, :confirm_phone, :verify_phone]
  before_action :require_admin!, only: [:export]

  def index
    @filters = sanitized_filters
    @hospedes = filtered_hospedes.order(:nome).page(params[:page]).per(10)
  end

  def export
    hospedes_scope = export_scope

    respond_to do |format|
      format.csv do
        send_data hospedes_csv(hospedes_scope),
                  filename: "hospedes-#{Time.current.strftime('%Y%m%d-%H%M')}.csv",
                  type: "text/csv"
      end

      format.pdf do
        pdf = Pdf::HospedesReport.new(hospedes_scope).render
        send_data pdf,
                  filename: "relatorio-hospedes-#{Time.current.strftime('%Y%m%d-%H%M')}.pdf",
                  type: "application/pdf",
                  disposition: :attachment
      end

      format.any do
        redirect_to hospedes_path, alert: "Formato de exportação não suportado."
      end
    end
  end

  def show 
  end 

  def new 
    @hospede = Hospede.new
  end 

  def create 
    @hospede = Hospede.new(hospede_params)
    if @hospede.save
        redirect_to confirm_phone_hospede_path(@hospede), notice: 'Hóspede criado com sucesso. Confirme o telefone com o código demo 0000.'
    else 
        render :new, status: :unprocessable_entity
    end 
  end 
  
  
  def edit 
  end 

  def update 
    if @hospede.update(hospede_params) 
        redirect_to @hospede, notice: 'Hóspede atualizado com sucesso.' 
    else 
    render :edit, status: :unprocessable_entity
    end 
end 

   def destroy 
    @hospede.destroy 
    redirect_to hospedes_path, notice: 'Hóspede excluído com sucesso.'
   end 

    def confirm_phone
      return redirect_to(@hospede, notice: 'Telefone já verificado.') if @hospede.phone_verified?

      @demo_code = Rails.configuration.x.phone_verification.demo_code
    end

    def verify_phone
      if @hospede.verify_phone!(params[:verification_code])
        redirect_to @hospede, notice: 'Telefone verificado com sucesso.'
      else
        @demo_code = Rails.configuration.x.phone_verification.demo_code
        flash.now[:alert] = 'Código inválido. Utilize 0000 enquanto estamos no MVP.'
        render :confirm_phone, status: :unprocessable_entity
      end
    end

  private

  def set_hospede
    @hospede = Hospede.find(params[:id])
  end

  def hospede_params
    params.require(:hospede).permit(:nome, :documento, :email, :telefone)
  end

  def sanitized_filters(source = params)
    {
      nome: source[:nome].to_s.strip,
      documento: source[:documento].to_s.strip,
      email: source[:email].to_s.strip
    }
  end

  def filtered_hospedes(scope = Hospede.all)
    filters = sanitized_filters

    if filters[:nome].present?
      scope = scope.where("UPPER(nome) LIKE ?", "%#{filters[:nome].upcase}%")
    end

    if filters[:documento].present?
      scope = scope.where("UPPER(documento) LIKE ?", "%#{filters[:documento].upcase}%")
    end

    if filters[:email].present?
      scope = scope.where("UPPER(email) LIKE ?", "%#{filters[:email].upcase}%")
    end

    scope
  end

  def export_scope
    scope = Hospede.order(:nome)
    return scope if params[:export_scope] == "all"

    filtered_hospedes(scope)
  end

  def hospedes_csv(scope)
    CSV.generate(headers: true) do |csv|
      csv << ["ID", "Nome", "Documento", "Email", "Telefone"]
      scope.each do |hospede|
        csv << [hospede.id, hospede.nome, hospede.documento, hospede.email, hospede.telefone]
      end
    end
  end
end
