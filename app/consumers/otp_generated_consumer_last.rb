# app/consumers/otp_generated_consumer.rb
class OtpGeneratedConsumerLast
  def self.start
    Rails.logger.info("Starting OTP Generated Consumer...")

    BrokerAdapter.subscribe('otp.generated') do |data|
      Rails.logger.info("Received OTP event: #{data}")

      # Construire le payload pour NotificationDispatcher
      payload = {
        "event_id"  => data["uuid"],
        "channel"   => data["channel"],
        "recipient" => data["identifier"],
        "message"   => case data["channel"]
                       when "email"
                         <<~HTML
                           <p>Hello,</p>
                           <p>Your OTP for #{data['context']} is <strong>#{data['otp_code']}</strong></p>
                           <p>Expires in 5 minutes.</p>
                         HTML
                       else
                         "#{data['context'].humanize} OTP: #{data['otp_code']}. Expires in 5 minutes."
                       end
      }

      # Déléguer à NotificationDispatcher
      NotificationDispatcher.call(payload)
    end
  rescue => e
    Rails.logger.error("OTP Generated Consumer error: #{e.class} - #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    sleep 5
    retry
  end
end