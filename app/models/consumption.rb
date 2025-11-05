class Consumption < ApplicationRecord
  belongs_to :reserva

  enum :status, {
    solicitado: "solicitado",
    em_atendimento: "em_atendimento",
    concluido: "concluido",
    negado: "negado"
  }

  validates :title, presence: true
  validates :status, presence: true
  validates :requested_by, inclusion: { in: %w[guest staff] }

  before_validation :set_requested_at
  after_create_commit :log_request_event
  before_save :sync_completion_timestamp, if: :will_save_change_to_status?
  after_update_commit :log_status_change_event, if: :saved_change_to_status?

  def requested_by_guest?
    requested_by == "guest"
  end

  private

  def set_requested_at
    self.requested_at ||= Time.current
  end

  def log_request_event
    reserva.log_event(
      "consumption_requested",
      metadata: {
        title: title,
        requested_by: localized_requested_by,
        status: status.titleize
      }
    )
  end

  def log_status_change_event
    previous_status = saved_change_to_status&.first
    previous_status_label = previous_status.present? ? previous_status.titleize : "—"
    reserva.log_event(
      "consumption_status_changed",
      metadata: {
        title: title,
        status: status.titleize,
        previous_status: previous_status_label
      }
    )
  end

  def sync_completion_timestamp
    self.completed_at = concluido? ? Time.current : nil
  end

  def localized_requested_by
    if requested_by_guest?
      I18n.t("reservas.consumptions.requested_by.guest", default: "Hóspede")
    else
      I18n.t("reservas.consumptions.requested_by.staff", default: "Equipe")
    end
  end
end
