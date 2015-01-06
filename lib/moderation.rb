require_relative 'moderation/version'
require_relative 'moderation/configuration'

require_relative 'moderation/storage'
# require_relative 'moderation/coercer'

module Moderation
  class Store
    extend Forwardable
    attr_reader :constructor, :construct_with, :limit, :storage, :coercer

    class << self
      attr_writer :configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.reset
      @configuration = Configuration.new
    end

    def self.configure
      yield(configuration)
    end

    def initialize(options = {})
      @constructor    = options.fetch(:constructor, :no_constructor)
      @construct_with = options.fetch(:construct_with, :no_construct_with)
      @limit          = options.fetch(:limit, Store.configuration.limit)
      @storage        = options.fetch(:storage) { Storage::InMemory.new }
      @coercer        = options.fetch(:coercer) do
        require_relative 'moderation/coercer/multi_json_coercer'
        Coercer::MultiJsonCoercer.new
      end
      @storage.limit  = @limit
    end

    def insert(item)
      storage.insert(self.coercer.dump(item))
    end

    def all(options = {})
      fetch_limit = options.fetch(:limit, limit)
      storage.all(limit: fetch_limit).map do |stored_item|
        if using_custom_constructor?
          constructor.send(construct_with, stored_item)
        elsif using_constructor?
          data = deserialize(stored_item)
          constructor.new(data)
        else
          deserialize(stored_item)
        end
      end
    end

    def_delegator :storage, :search

    def moderation_required?
      storage.all(limit: 1).size > 0
    end

    def_delegator :storage, :clean!

    private

    def deserialize serialized_data
      self.coercer.load(serialized_data, symbolize_keys: true)
    end

    def using_constructor?
      constructor != :no_constructor
    end

    def using_custom_constructor?
      using_constructor? && construct_with != :no_construct_with
    end
  end
end
