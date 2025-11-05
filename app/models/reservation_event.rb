class ReservationEvent < ApplicationRecord
  belongs_to :reserva
  belongs_to :performed_by, class_name: "User", optional: true

  validates :event_type, presence: true

  def timestamp
    metadata_timestamp = metadata.is_a?(Hash) ? metadata["timestamp"] : nil
    metadata_timestamp.present? ? Time.zone.parse(metadata_timestamp.to_s) : created_at
  rescue ArgumentError
    created_at
  end

  def human_label
    I18n.t("reservas.events.#{event_type}.label", default: event_type.humanize)
  end

  def details_message
    I18n.t(
      "reservas.events.#{event_type}.details",
      default: nil,
      title: metadata&.fetch("title", nil),
      status: metadata&.fetch("status", nil),
      previous_status: metadata&.fetch("previous_status", nil),
      requested_by: metadata&.fetch("requested_by", nil),
      reason: metadata&.fetch("reason", nil)
    )
  end

  def icon_name
    I18n.t("reservas.events.#{event_type}.icon", default: "bi-activity")
  end
end
