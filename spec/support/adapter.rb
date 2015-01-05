require_relative '../../lib/moderation/storage'

module Moderation
  class Adapter

    attr_reader :storage

    def initialize adapter='memory'
      case adapter
      when 'memory'
        @storage = Storage::InMemory.new
      when 'redis'
        @storage = Storage::Redis.new(collection: 'collection_test', server: MockRedis.new)
      else
        raise 'Unsupported storage'
      end
    end

    def options options={}
      options.merge(storage: self.storage)
    end
  end
end