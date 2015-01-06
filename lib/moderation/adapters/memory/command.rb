module Moderation
  module Adapters
    module Memory
      class Command

        def initialize(collection, limit)
          @dataset = collection.dataset
          @limit = limit
        end

        def insert(item)
          @dataset.unshift(item)

          if @dataset.count > @limit
            @dataset.pop(@dataset.count - @limit)
          end
          @dataset
        end

        def delete(item, attribute=nil)
          @dataset.delete_if do |entry|
            MultiJson.load(entry, symbolize_keys: true) == item
          end
        end

      end
    end
  end
end
