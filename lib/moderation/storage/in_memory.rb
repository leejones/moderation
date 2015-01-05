require_relative '../abstract_storage'

module Moderation
  module Storage
    class InMemory < Moderation::AbstractStorage
      attr_accessor :limit

      def initialize(options = {})
        @limit = options.fetch(:limit, Store.configuration.limit)
      end

      def insert(item)
        data.unshift(item)
        if data.count > @limit
          data.pop(data.count - @limit)
        end
        data
      end

      def all(options = {})
        fetch_limit = options.fetch(:limit, limit)
        data.first(fetch_limit)
      end

      def clean!
        @data = []
      end

      private

      def data
        @data ||= []
      end
    end
  end
end
