class BrokerAdapter
  def self.subscribe(topic, &block)
    case BROKER_TYPE
    when 'rabbitmq'
      # Création d'un exchange durable
      exchange = BROKER_CHANNEL.topic(topic, durable: true)

      # Crée une queue durable (nom unique ou topic + "_queue")
      queue_name = "#{topic}_queue"
      queue = BROKER_CHANNEL.queue(queue_name, durable: true)

      # Bind la queue à l'exchange (routing_key '#' pour tout recevoir)
      queue.bind(exchange, routing_key: '#')
      Rails.logger.info("Queue '#{queue_name}' bound to exchange '#{topic}'")

      # Consommation des messages
      queue.subscribe(manual_ack: true, block: false) do |delivery_info, properties, payload|
        handle_message(delivery_info, payload, &block)
      end

    when 'kafka'
      consumer = BROKER_CONN.consumer(group_id: 'notification_service')
      consumer.subscribe(topic)
      consumer.each_message do |message|
        handle_message(nil, message.value, &block)
      end

    else
      raise "BROKER_TYPE inconnu: #{BROKER_TYPE}"
    end
  end

  def self.handle_message(delivery_info, payload, &block)
    begin
      data = JSON.parse(payload)
      block.call(data)
      BROKER_CHANNEL.ack(delivery_info.delivery_tag) if delivery_info
    rescue => e
      BROKER_CHANNEL.nack(delivery_info.delivery_tag, false, true) if delivery_info
      Rails.logger.error("Error handling message: #{e.class} - #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
    end
  end
end