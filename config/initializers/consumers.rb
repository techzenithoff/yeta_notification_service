# Ne pas bloquer le thread principal de Rails
consumer_classes = [
  OtpGeneratedConsumer,
  # Ajoute ici d'autres consumers au fur et à mesure
  # UserRegisteredConsumer,
  # PaymentSucceededConsumer
]

consumer_classes.each do |consumer_class|
  Thread.new do
    begin
      Rails.logger.info("Starting consumer: #{consumer_class.name}...")
      consumer_class.start
    rescue => e
      Rails.logger.error("Failed to start consumer #{consumer_class.name}: #{e.class} - #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      sleep 5
      retry
    end
  end
end