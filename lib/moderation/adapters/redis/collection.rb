require 'redis/namespace'

module Moderation
  module Adapters
    module Redis
      class Collection

        def initialize(options = {})
          @server = options.fetch(:server, nil)
        end

        def dataset
          @dataset ||= begin
            # graciously borrowed from https://github.com/defunkt/resque
            case @server
            when String
              if @server['redis://']
                redis_connection = ::Redis.connect(url: @server, thread_safe: true)
              else
                url, namespace = @server.split('/', 2)
                host, port, db = @server.split(':')
                redis_connection = ::Redis.new(host: host, port: port, thread_safe: true, db: db)
              end
              namespace ||= :moderation

              ::Redis::Namespace.new(namespace, redis: redis_connection)
            when ::Redis::Namespace
              @server
            else
              ::Redis::Namespace.new(:moderation, redis: @server)
            end
          end
        end

      end
    end
  end
end
