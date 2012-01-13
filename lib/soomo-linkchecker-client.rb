require 'json'
require 'amqp'

require 'soomo/link_checker/client/version'
require 'soomo/link_checker/client/configuration'

module Soomo
  module LinkChecker

    def self.configure(&block)
      yield configuration
    end

    def self.watch_for_updates
      connect do |channel|
        exchange = channel.topic("soomo.events", :durable => true)
        queue = channel.queue(configuration.update_queue_name, :durable => true)
        queue.bind(exchange, :routing_key => "#.update.link.status.#")
        queue.subscribe(:ack => true) do |metadata, payload|
          link = JSON.parse(payload)
          configuration.on_link_update_block.call(link['url'], link['status'], link['reason'])
          metadata.ack
        end
      end
    end

    def self.push( urls )
      connect do |channel|
        exchange = channel.topic("soomo.events", :durable => true)
        Array(urls).each do |url|
          message = {:url => url}.to_json
          exchange.publish(message, :routing_key => "create.link", :app_id => configuration.app_id)
        end
      end
    end

    def self.pull( urls )
      connect do |channel|
        exchange = channel.topic("soomo.events", :durable => true)
        Array(urls).each do |url|
          message = {:url => url}.to_json
          exchange.publish(message, :routing_key => "delete.link", :app_id => configuration.app_id)
        end
      end
    end

    protected

    def self.connect( &block )
      AMQP.connect(Soomo::LinkChecker.configuration.broker) do |connection|
        block.call(AMQP::Channel.new(connection))
      end
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

  end
end
