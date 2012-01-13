module Soomo
  module LinkChecker
    class Configuration

      attr_accessor :broker
      attr_reader   :on_link_update_block

      def initialize
        @broker = { :host => '127.0.0.1' }
      end

      def on_link_update(&block)
        @on_link_update_block = block
      end

      def update_queue_name
        raise 'Missing client name.' unless @client_name
        @queue_name ||= "soomo.link.updates.#{@client_name}"
      end

      def app_id
        raise 'Missing client name.' unless @client_name
        @client_name
      end

      def client_name=(name)
        @queue_name = nil
        @client_name = name
      end

    end
  end
end
