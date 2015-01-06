module Moderation
  module Adapters
    module Implementation

      def search key, value
        all.select do |entry|
          JSON.load(entry)[key.to_s] == value
        end
      end

    end
  end
end
