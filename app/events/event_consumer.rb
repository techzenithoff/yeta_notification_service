class EventConsumer
    def self.consume(topic, &block)
        case BROKER_TYPE
        when 'rabbitmq'
            queue = BROKER_CHANNEL.queue(topic, durable: true)
            queue.subscribe(manual_ack: true, block: false) do |delivery_info, properties, payload|
                begin
                    block.call(JSON.parse(payload))
                    BROKER_CHANNEL.ack(delivery_info.delivery_tag)
                rescue => e
                    BROKER_CHANNEL.nack(delivery_info.delivery_tag, false, true)
                    Rails.logger.error("RabbitMQ consume error: #{e.message}")
                end
            end
        when 'kafka'
            consumer = BROKER_CONN.consumer(group_id: 'notification_service')
            consumer.subscribe(topic)
            consumer.each_message do |message|
                begin
                    block.call(JSON.parse(message.value))
                rescue => e
                    Rails.logger.error("Kafka consume error: #{e.message}")
                end
            end
        end
    end
end