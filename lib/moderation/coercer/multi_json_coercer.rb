require_relative '../abstract_coercer'

require 'multi_json'

module Coercer
  class MultiJsonCoercer < Moderation::AbstractCoercer

    def dump data, options={}
      MultiJson.dump(data)
    end

    def load data, options={}
      MultiJson.load(data, options)
    end

  end
end
