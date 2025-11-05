module Guests
  class ReservasController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_hospede!
    before_action :set_hospede
    before_action :set_reserva, only: :show

    def index
      @reservas = @hospede.reservas.includes(:hotel).order(data_checkin: :asc)
    end

    def show
      @consumptions = @reserva.consumptions.order(requested_at: :desc)
      @timeline_entries = @reserva.timeline_entries
    end

    private

    def ensure_hospede!
      allowed = current_user.respond_to?(:hospede?) && current_user.hospede?
      allowed &&= current_user.hospede_record.present?
      redirect_to authenticated_root_path, alert: "Acesso restrito ao hóspede." unless allowed
    end

    def set_hospede
      @hospede = current_user.hospede_record
    end

    def set_reserva
      @reserva = @hospede.reservas.find(params[:id])
    end
  end
end
