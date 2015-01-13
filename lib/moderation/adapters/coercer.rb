module Moderation
  module Adapters
    module Coercer

      def deserialize item
        MultiJson.load(item, symbolize_keys: true)
      end

      def serialize item
        MultiJson.dump(item)
      end

    end
  end
end
