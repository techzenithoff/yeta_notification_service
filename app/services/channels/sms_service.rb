module Channels
  class SmsService
    def self.call(recipient:, subject:, body:, payload:)
      new(recipient, body).call
    end

    def initialize(recipient, message)
      @recipient = recipient
      @message   = message
    end

    def call
      raise ArgumentError, "Recipient missing" if @recipient.blank?
      raise ArgumentError, "Message missing"   if @message.blank?

      formatted_phone = format_phone(@recipient)
      sms_client.send(sms_sender, formatted_phone, @message)

      Rails.logger.info("[SmsService] SMS envoyé à #{formatted_phone}")
    end

    private

    def sms_client
      @sms_client ||= ArolitecSms::Client.new
    end

    def sms_sender
      ENV["SMS_SENDER"]
    end

    def format_phone(phone)
      phone = phone.gsub(/\D/, '')
      phone.start_with?('+') ? phone : "+#{phone}"
    end
  end
end