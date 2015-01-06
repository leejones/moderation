require 'moderation/adapters/abstract'
require 'moderation/adapters/implementation'
require 'moderation/adapters/memory/collection'
require 'moderation/adapters/memory/command'
require 'moderation/adapters/memory/query'

module Moderation
  module Adapters
    class MemoryAdapter < Abstract
      include Implementation

      def_delegator :command, :insert
      def_delegator :command, :delete
      def_delegator :query, :all

      def clean!
        @collection = Memory::Collection.new
      end

      protected

      def command
        Memory::Command.new(_collection, self.limit)
      end

      def query &blk
        Memory::Query.new(_collection, self.limit, &blk)
      end

      private

      def _collection
        @collection ||= Memory::Collection.new
      end

    end
  end
end
