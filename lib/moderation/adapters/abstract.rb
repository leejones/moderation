module Moderation
  module Adapters
    class Abstract
      extend Forwardable

      attr_accessor :limit

      def initialize(options = {})
        @limit = options.fetch(:limit) { Store.configuration.limit }
      end

      def insert data
        raise NotImplementedError
      end

      def all options = {}
        raise NotImplementedError
      end

      def search key, value
        raise NotImplementedError
      end

      def moderation_required?
        raise NotImplementedError
      end

      def clean!
        raise NotImplementedError
      end

    end
  end
end
