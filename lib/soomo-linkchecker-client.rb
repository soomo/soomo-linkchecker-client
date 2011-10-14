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
        queue = channel.queue( configuration.queue_name, :durable => true )
        queue.subscribe(:ack => true) do |metadata, payload|
          _link = JSON.parse( payload )
          url, status, reason = [ _link['url'], _link['status'], _link['reason'] ]
          configuration.on_link_update_block.call( url, status, reason )
          metadata.ack
        end
      end
    end

    def self.push( urls )
      connect do |channel|
        exchange = channel.direct( "" )
        urls.each do |url|
          exchange.publish( url, :routing_key => configuration.server_routing_key, :reply_to => configuration.client_routing_key )
        end
      end
    end

    protected

    def self.connect( &block )
      AMQP.connect( Soomo::LinkChecker.configuration.broker ) do |connection|
        block.call( AMQP::Channel.new( connection ) )
      end
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

  end
end
