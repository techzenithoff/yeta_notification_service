# app/services/notifications/notification_dispatcher.rb
class NotificationDispatcher
  # payload attendu :
  # {
  #   "event_id" => "uuid",
  #   "channel" => "email/sms/whatsapp",
  #   "recipient" => "email ou phone",
  #   "context" => "registration/login/etc",
  #   "data" => { "otp" => "123456" }
  # }

  def self.call(payload)
    Rails.logger.info("[Dispatcher] Start dispatching notification for event_id=#{payload['event_id']} channel=#{payload['channel']} recipient=#{payload['recipient']} context=#{payload['context']}")

    if Notification.exists?(event_id: payload["event_id"])
      Rails.logger.info("[Dispatcher] Notification already exists for event_id=#{payload['event_id']}, skipping")
      return
    end

    # Résolution du message via le resolver
    resolved = MessageResolver.resolve!(
      payload["context"],
      channel: payload["channel"],
      **(payload["data"] || {})
    )
    Rails.logger.info("[Dispatcher] Message resolved for event_id=#{payload['event_id']}: subject='#{resolved[:subject]}', body='#{resolved[:body]}'")

    # Création de l'enregistrement Notification
    Notification.create!(
      event_id:  payload["event_id"],
      channel:   payload["channel"],
      recipient: payload["recipient"],
      status:    :pending
    )
    Rails.logger.info("[Dispatcher] Notification record created for event_id=#{payload['event_id']}")

    # Enqueue du job Sidekiq
    NotificationJob.perform_async(
      payload.merge(
        "subject"  => resolved[:subject],
        "message"  => resolved[:body],
        "template" => resolved[:template]
      )
    )
    Rails.logger.info("[Dispatcher] NotificationJob enqueued for event_id=#{payload['event_id']}")

  rescue => e
    Rails.logger.error("[Dispatcher] Error for event_id=#{payload['event_id']}: #{e.class} - #{e.message}")
    raise e
  end
end