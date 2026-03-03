# app/consumers/otp_generated_consumer.rb
class OtpGeneratedConsumer
  def self.start
    Rails.logger.info("[Consumer] Starting OTP Generated Consumer...")

    BrokerAdapter.subscribe('otp.generated') do |data|
      Rails.logger.info("[Consumer] Received OTP event: #{data.inspect}")

      # Construire le payload pour NotificationDispatcher
      payload = {
        "event_id"  => data["uuid"],
        "channel"   => data["channel"],
        "recipient" => data["identifier"],
        "context"   => data["context"],
        "data"      => { "otp" => data["otp_code"] }
      }
      Rails.logger.info("[Consumer] Payload built for dispatcher: #{payload.inspect}")

      # Déléguer à NotificationDispatcher
      NotificationDispatcher.call(payload)
      Rails.logger.info("[Consumer] Notification dispatched for event_id=#{payload['event_id']}")
    end
  rescue => e
    Rails.logger.error("[Consumer] OTP Generated Consumer error: #{e.class} - #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    sleep 5
    retry
  end
end