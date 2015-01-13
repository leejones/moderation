require 'moderation/adapters/coercer'

module Moderation
  module Adapters
    class Abstract
      extend Forwardable

      attr_accessor :limit

      def initialize(options = {})
        @limit = options.fetch(:limit) { Store.configuration.limit }
      end

      # Commands

      def insert data
        raise NotImplementedError
      end

      def clean!
        raise NotImplementedError
      end

      # Public: Remove item from dataset
      #
      # item - Item (Instance of object itself)
      #
      # Examples
      #   delete({ip_address: '222.333.44.01'})
      #   # => 0 (items removed)
      #
      # Returns number of item removed
      def delete item
        raise NotImplementedError
      end

      # Public: Remove item from dataset from query
      #
      # key   - String or Symobol
      # value - Object
      #
      # Examples
      #   delete_query(:ip_address, '222.333.44.01')
      #   # => 1 (items removed)
      #
      # Returns number of item removed
      def delete_query key, value
        raise NotImplementedError
      end

      # Queries

      def all options = {}
        raise NotImplementedError
      end

      def search key, value
        raise NotImplementedError
      end

      def moderation_required?
        raise NotImplementedError
      end

    end
  end
end
