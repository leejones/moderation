module Moderation
  module Adapters
    module Implementation

      def search key, value
        all.select do |entry|
          MultiJson.load(entry, symbolize_keys: true)[key.to_sym] == value
        end
      end

      def delete_query key, value
        removed_item = 0
        search(key, value).each do |entry|
          removed_item += delete(MultiJson.load(entry, symbolize_keys: true))
        end
        removed_item
      end

    end
  end
end
