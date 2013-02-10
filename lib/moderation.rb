require 'moderation/version'
require 'multi_json'

class Moderation
  attr_reader :constructor, :construct_with, :limit, :storage
  autoload 'Storage', 'moderation/storage.rb'
  DEFAULT_LIMIT = 25

  def initialize(options = {})
    @constructor = options[:constructor]
    @construct_with = options[:construct_with]
    @limit = options.fetch(:limit, DEFAULT_LIMIT)
    @storage = options.fetch(:storage, Storage::InMemory.new)
    @storage.limit = @limit
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
        data = MultiJson.load(stored_item, :symbolize_keys => true)
        constructor.new(data)
      else
        MultiJson.load(stored_item, :symbolize_keys => true)
      end
    end
  end

  private

  def using_constructor?
    ! constructor.nil?
  end

  def using_custom_constructor?
    using_constructor? && ! construct_with.nil? 
  end
end

