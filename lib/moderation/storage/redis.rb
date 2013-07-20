require 'redis/namespace'

class Moderation
  class Storage
    class Redis
      attr_reader :collection, :server
      attr_accessor :limit

      def initialize(options = {}) 
        @limit = options.fetch(:limit, Moderation::DEFAULT_LIMIT)
        @collection = options.fetch(:collection)
        @server = options.fetch(:server, nil)
      end

      def insert(item)
        transaction do
          redis.lpush(collection, item)
          redis.ltrim(collection, 0, (limit - 1))
        end
      end

      def all(options = {})
        fetch_limit = options.fetch(:limit, limit).to_i - 1
        redis.lrange(collection, 0, fetch_limit) || []
      end

      private

      def redis
        @redis ||= begin
          # graciously borrowed from https://github.com/defunkt/resque
          case server
          when String
            if server['redis://']
              redis_connection = ::Redis.connect(:url => server, :thread_safe => true)
            else
              url, namespace = server.split('/', 2)
              host, port, db = server.split(':')
              redis_connection = ::Redis.new(:host => host, :port => port,
                :thread_safe => true, :db => db)
            end
            namespace ||= :moderation

            ::Redis::Namespace.new(namespace, :redis => redis_connection)
          when ::Redis::Namespace
            server
          else
            ::Redis::Namespace.new(:moderation, :redis => server)
          end
        end
      end

      def transaction(&block)
        if transactions_supported?
          redis.multi { yield }
        else
          yield
        end
      end

      def transactions_supported?
        @transactions_supported ||= begin
          redis_version.split('.').first.to_i >= 2 && redis.respond_to?(:multi)
        end
      end

      def redis_version
        @redis_version ||= redis.info["redis_version"]
      end
    end
  end
end

