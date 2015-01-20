require_relative 'moderation/version'
require_relative 'moderation/configuration'
require_relative 'moderation/storage'

module Moderation
  class Store
    extend Forwardable
    include Adapters::Coercer

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

    def_delegator :storage, :insert

    def all(options = {})
      fetch_limit = options.fetch(:limit, limit)
      storage.all(limit: fetch_limit).map { |item| deserialize(item) }
    end

    def deserialize item
      if using_custom_constructor?
        constructor.send(construct_with, unmarshalling(item))
      elsif using_constructor?
        constructor.new(unmarshalling(item))
      else
        unmarshalling(item)
      end
    end

    # def_delegator :storage, :search
    def search key, value
      storage.search(key, value).map { |item| deserialize(item) }
    end

    # Public: Ask if there are some recorded moderation
    # You can ask for general or you can pass search critera
    #
    # key   - String or Symobol
    # value - Object
    #
    # Examples
    #
    #   moderation_required?
    #   # => true | false
    #
    #   moderation_required? :id, 1
    #   # => true | false
    #
    # Returns boolean if there are or not moderations recorded
    def moderation_required? *args
      key, value = args
      if key && value
        storage.search(key, value)
      else
        storage.all(limit: 1)
      end.size > 0
    end

    def_delegator :storage, :clean!
    def_delegator :storage, :delete
    def_delegator :storage, :delete_query

    private

    def using_constructor?
      constructor != :no_constructor
    end

    def using_custom_constructor?
      using_constructor? && construct_with != :no_construct_with
    end
  end
end
