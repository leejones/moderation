require 'moderation/adapters/abstract'
require 'moderation/adapters/implementation'
require 'moderation/adapters/redis/collection'
require 'moderation/adapters/redis/transaction'
require 'moderation/adapters/redis/command'
require 'moderation/adapters/redis/query'

module Moderation
  module Adapters
    class RedisAdapter < Abstract
      include Implementation

      attr_reader :name

      def initialize(options = {})
        super
        @name   = options.fetch(:name, 'default')
        @server = options.fetch(:server, nil)
      end

      def_delegator :command, :insert
      def_delegator :command, :delete
      def_delegator :command, :clean!
      def_delegator :query, :all

      protected

      def command
        Redis::Command.new(_collection, self.name, self.limit)
      end

      def query &blk
        Redis::Query.new(_collection, self.name, self.limit, &blk)
      end

      private

      def _collection
        @collection ||= Redis::Collection.new(server: @server)
      end

    end
  end
end
