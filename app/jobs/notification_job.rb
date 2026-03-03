# app/jobs/notification_job.rb
class NotificationJob
  include Sidekiq::Worker
  sidekiq_options retry: 10

  CHANNEL_SERVICES = {
    "email"    => ::Channels::EmailService,
    "sms"      => ::Channels::SmsService,
    "whatsapp" => ::Channels::WhatsappService
  }.freeze

  def perform(payload)
    event_id  = payload["event_id"]
    channel   = payload["channel"]
    recipient = payload["recipient"]
    subject   = payload["subject"]
    message   = payload["message"]

    Rails.logger.info("Sending notification #{event_id} via #{channel} to #{recipient}")

    service_class = CHANNEL_SERVICES[channel]

    raise "Unsupported channel: #{channel}" unless service_class

    service_class.call(
      recipient: recipient,
      subject: subject,
      body: message,
      payload: payload
    )

    update_status(event_id, :sent)

  rescue => e
    Rails.logger.error("Failed notification #{event_id}: #{e.class} - #{e.message}")
    update_status(event_id, :failed, e.message)
    raise e
  end

  private

  def update_status(event_id, status, error = nil)
    return unless event_id.present?

    notification = Notification.find_by(event_id: event_id)
    return unless notification

    notification.update(
      status: status,
      error: error
    )
  end
end