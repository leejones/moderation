require_relative 'moderation/version'
require_relative 'moderation/configuration'
require_relative 'moderation/storage'

require 'multi_json'

module Moderation
  class Store
    extend Forwardable
    attr_reader :constructor, :construct_with, :limit, :storage

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
      @storage        = options.fetch(:storage) { Adapters::MemoryAdapter.new }
      @storage.limit  = @limit
    end

    def insert(item)
      storage.insert(MultiJson.dump(item))
    end

    def all(options = {})
      fetch_limit = options.fetch(:limit, limit)
      storage.all(limit: fetch_limit).map do |stored_item|
        if using_custom_constructor?
          constructor.send(construct_with, stored_item)
        elsif using_constructor?
          data = MultiJson.load(stored_item, symbolize_keys: true)
          constructor.new(data)
        else
          MultiJson.load(stored_item, symbolize_keys: true)
        end
      end
    end

    def_delegator :storage, :search

    def moderation_required?
      storage.all(limit: 1).size > 0
    end

    def_delegator :storage, :clean!
    def_delegator :storage, :delete

    private

    def using_constructor?
      constructor != :no_constructor
    end

    def using_custom_constructor?
      using_constructor? && construct_with != :no_construct_with
    end
  end
end
