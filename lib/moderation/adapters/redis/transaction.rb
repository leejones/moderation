module Moderation
  module Adapters
    module Redis
      module Transaction

        def transaction(&block)
          if transactions_supported?
            @dataset.multi { yield }
          else
            yield
          end
        end

        def transactions_supported?
          @transactions_supported ||= begin
            redis_version.split('.').first.to_i >= 2 && @dataset.respond_to?(:multi)
          end
        end

        def redis_version
          @redis_version ||= @dataset.info['redis_version']
        end

      end
    end
  end
end
