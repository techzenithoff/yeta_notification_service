# app/services/channels/email_service.rb
  module Channels
    class EmailService
      def self.call(recipient:, subject:, body:, payload:)
        if payload["template"].present?
          NotificationMailer
            .with(data: payload["data"])
            .public_send(payload["template"], recipient, subject)
            .deliver_now
        else
          NotificationMailer
            .generic_email(recipient, subject, body)
            .deliver_now
        end
      end
    end
  end
