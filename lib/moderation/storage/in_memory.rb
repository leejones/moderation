class Moderation
  class Storage
    class InMemory 
      attr_accessor :limit

      def initialize(limit = Moderation::DEFAULT_LIMIT)
        @limit = limit
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

      private

      def data
        @data ||= []
      end
    end
  end
end

