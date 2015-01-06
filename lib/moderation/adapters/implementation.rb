module Moderation
  module Adapters
    module Implementation

      def search key, value
        all.select do |entry|
          deserialize(entry)[key.to_sym] == value
        end
      end

    end
  end
end
