module Moderation
  module Adapters
    module Memory
      class Command
        include Adapters::Coercer

        def initialize(collection, limit)
          @dataset = collection.dataset
          @limit = limit
        end

        def insert(item)
          @dataset.unshift(marshalling(item))

          if @dataset.count > @limit
            @dataset.pop(@dataset.count - @limit)
          end
          @dataset
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
        def delete(item)
          initial_size = @dataset.size
          final_size   = @dataset.delete_if do |entry|
            unmarshalling(entry) == item
          end.size
          initial_size - final_size
        end

      end
    end
  end
end
