module Soomo
  module LinkChecker
    class Configuration

      attr_accessor :broker
      attr_reader   :server_routing_key, :on_link_update_block

      def initialize
        @broker = { :host => '127.0.0.1' }
        @server_routing_key = "soomo.links.api"
      end

      def on_link_update(&block)
        @on_link_update_block = block
      end

      def queue_name
        raise 'Missing client name.' unless @client_name
        @queue_name ||= "soomo.links.clients.#{@client_name}"
      end
      alias_method :client_routing_key, :queue_name

      def client_name=(name)
        @queue_name = nil
        @client_name = name
      end

    end
  end
end
