require 'moderation/version'

class Moderation
  attr_reader :constructor, :construct_with, :limit, :storage
  autoload 'Storage', 'moderation/storage.rb'
  DEFAULT_LIMIT = 25

  def initialize(options = {})
    @constructor = options[:constructor]
    @construct_with = options[:construct_with]
    @limit = options.fetch(:limit, DEFAULT_LIMIT)
    @storage = options.fetch(:storage, Storage::InMemory.new(@limit))
  end

  def insert(item)
    storage.insert(item.to_json)
  end

  def all(options = {})
    fetch_limit = options.fetch(:limit, limit)
    storage.all(limit: fetch_limit).map do |stored_item|
      if using_custom_constructor?
        constructor.send(construct_with, stored_item)
      elsif using_constructor?
        data = JSON.parse(stored_item, :symbolize_names => true) 
        constructor.new(data)
      else
        JSON.parse(stored_item, :symbolize_names => true) 
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

