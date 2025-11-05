class Reserva < ApplicationRecord
  KIOSK_TOKEN_BYTES = 16 unless const_defined?(:KIOSK_TOKEN_BYTES)

  belongs_to :hotel
  belongs_to :hospede
  belongs_to :confirmed_by, class_name: "User", optional: true

  has_many :consumptions, dependent: :destroy
  has_many :reservation_events, -> { order(created_at: :asc) }, dependent: :destroy
  has_many :reservation_rooms, dependent: :destroy
  has_many :quartos, through: :reservation_rooms

  enum :status, {
    reservada: "reservada",
    confirmada: "confirmada",
    checked_in: "checked_in",
    checked_out: "checked_out",
    cancelada: "cancelada"
  }

  validates :data_checkin, presence: true
  validates :data_checkout, presence: true, comparison: { greater_than: :data_checkin }
  validates :status, presence: true
  validates :valor_total, presence: true, numericality: { greater_than: 0 }

  before_validation :apply_default_status
  before_create :generate_kiosk_token

  scope :awaiting_phone_verification, -> {
    reservada.joins(:hospede).where(hospedes: { phone_verified_at: nil })
  }

  scope :ready_for_confirmation, -> {
    reservada.joins(:hospede).where.not(hospedes: { phone_verified_at: nil })
  }

  scope :awaiting_operations, -> { reservada }

  def mark_confirmed_by!(user)
    return false unless can_be_confirmed?

    transaction do
      update!(status: "confirmada", confirmed_at: Time.current, confirmed_by: user)
      log_event("confirmed", metadata: { via: "admin_panel" }, actor: user)
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def mark_checked_in!(user = nil)
    return false unless can_check_in?

    transaction do
      update!(status: "checked_in", check_in_at: Time.current)
      log_event("checked_in", metadata: { via: event_origin(user) }, actor: user)
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def mark_checked_out!(user = nil)
    return false unless can_check_out?

    transaction do
      update!(status: "checked_out", check_out_at: Time.current)
      log_event("checked_out", metadata: { via: event_origin(user) }, actor: user)
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def cancel!(user = nil, reason: nil)
    return false if cancelada? || checked_out?

    transaction do
      update!(status: "cancelada")
      metadata = { via: event_origin(user) }
      metadata[:reason] = reason if reason.present?
      log_event("cancelled", metadata:, actor: user)
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def can_be_confirmed?
    reservada? && hospede&.phone_verified?
  end

  def can_check_in?
    (reservada? || confirmada?) && hospede&.phone_verified?
  end

  def can_check_out?
    checked_in?
  end

  def kiosk_link
    Rails.application.routes.url_helpers.reservation_checkpoint_url(kiosk_token, host: Rails.application.config.x.default_host)
  end

  def timeline_entries
    base_entries = [
      { label: I18n.t("reservas.timeline.created"), timestamp: created_at, icon: "bi-flag" }
    ]

    base_entries << { label: I18n.t("reservas.timeline.confirmed"), timestamp: confirmed_at, icon: "bi-patch-check" } if confirmed_at.present?
    base_entries << { label: I18n.t("reservas.timeline.checked_in"), timestamp: check_in_at, icon: "bi-door-open" } if check_in_at.present?
    base_entries << { label: I18n.t("reservas.timeline.checked_out"), timestamp: check_out_at, icon: "bi-door-closed" } if check_out_at.present?

    (base_entries + reservation_events.map do |event|
      next if event.timestamp.blank?

      {
        label: event.human_label,
        timestamp: event.timestamp,
        icon: event.icon_name,
        details: event.details_message
      }
    end.compact).sort_by { |entry| entry[:timestamp] || Time.current }
  end

  def log_event(event_type, metadata: {}, actor: nil)
    reservation_events.create!(event_type:, metadata:, performed_by: actor)
  end

  def assigned_quartos_label
    return I18n.t("reservas.quartos.none_assigned", default: "Nenhum quarto atribuído") if quartos.empty?

    quartos.includes(:hotel, :room_type).map do |quarto|
      [quarto.numero, quarto.room_type&.nome, quarto.hotel&.nome].compact.join(" - ")
    end.join(", ")
  end

  private

  def apply_default_status
    self.status = "reservada" if status.blank?
  end

  def generate_kiosk_token
    self.kiosk_token ||= loop do
      candidate = SecureRandom.urlsafe_base64(KIOSK_TOKEN_BYTES)
      break candidate unless self.class.exists?(kiosk_token: candidate)
    end
  end

  def event_origin(user)
    return "system" if user.nil?
    user.admin? ? "admin_panel" : "guest_portal"
  end
end
