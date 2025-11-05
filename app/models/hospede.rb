class Hospede < ApplicationRecord
    has_many :reservas

    validates :nome, presence: true
    validates :documento, presence: true, uniqueness: true
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
    validates :telefone, presence: true

    before_create :prepare_demo_phone_verification

    def phone_verified?
        phone_verified_at.present?
    end

    def verify_phone!(submitted_code)
        return false if phone_verified?

        normalized_code = submitted_code.to_s.strip
        return false if normalized_code.blank?

        if matches_demo_code?(normalized_code) || secure_code_match?(normalized_code, phone_verification_code.to_s)
            transaction do
                update!(phone_verified_at: Time.current)
                reservas.reservada.find_each do |reserva|
                    reserva.log_event("phone_verified", metadata: { via: "demo_code" })
                    reserva.touch(:updated_at)
                end
            end
            true
        else
            false
        end
    end

    private

    def prepare_demo_phone_verification
        self.phone_verification_code = demo_code if phone_verification_code.blank?
        self.phone_verification_sent_at = Time.current
    end

    def demo_code
        Rails.configuration.x.phone_verification.demo_code
    end

    def matches_demo_code?(code)
        demo = demo_code.to_s
        demo.present? && code.length == demo.length && ActiveSupport::SecurityUtils.secure_compare(code, demo)
    end

    def secure_code_match?(code, reference)
        reference.present? && code.length == reference.length && ActiveSupport::SecurityUtils.secure_compare(code, reference)
    end
end
