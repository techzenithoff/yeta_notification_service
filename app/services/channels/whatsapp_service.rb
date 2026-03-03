# app/services/services/channels/whatsapp_service.rb

  module Channels
    class WhatsappService
      def self.call(payload)
        recipient = payload["recipient"]
        message   = payload["message"]

        Rails.logger.info "Sending WhatsApp to #{recipient}: #{message}"
        # Intégration avec Twilio WhatsApp API ou autre
      end

      def self.send_otp(to, message)
        call("recipient" => to, "message" => message)
      end
    end
  end
