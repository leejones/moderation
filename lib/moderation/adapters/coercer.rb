require 'multi_json'

module Moderation
  module Adapters
    module Coercer

      def unmarshalling item
        MultiJson.load(item, symbolize_keys: true)
      end

      def marshalling item
        MultiJson.dump(item)
      end

    end
  end
end
