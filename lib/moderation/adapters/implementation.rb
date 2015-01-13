module Moderation
  module Adapters
    module Implementation
      include Adapters::Coercer

      def search key, value
        all.select do |entry|
          deserialize(entry)[key.to_sym] == value
        end
      end

      def delete_query key, value
        removed_item = 0
        search(key, value).each do |entry|
          removed_item += delete(deserialize(entry))
        end
        removed_item
      end

    end
  end
end
