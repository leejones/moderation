require 'spec_helper'

require_relative '../../lib/moderation/storage/in_memory'

module Moderation
  module Storage
    describe InMemory do
      it 'initializes with a default limit of 25' do
        storage = InMemory.new
        storage.limit.should eql(25)
      end

      it 'accepts a custom limit of 200' do
        storage = InMemory.new(limit: 200)
        storage.limit.should eql(200)
      end

      it 'accepts a new limit' do
        storage = InMemory.new(limit: 200)
        storage.limit = 100
        storage.limit.should eql(100)
      end

      it 'inserts data' do
        storage = InMemory.new
        storage.insert('treadstone')
        storage.all.should eql(['treadstone'])
      end

      it 'returns all data' do
        numbers = InMemory.new
        Array(0..10).each { |n|  numbers.insert(n) }
        numbers.all.should eql([10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0])
      end

      it 'returns a subset of data' do
        numbers = InMemory.new
        Array(0..10).each { |n|  numbers.insert(n) }
        numbers.all(:limit => 5).should eql([10, 9, 8, 7, 6])
      end

      it 'returns an empty Array' do
        numbers = InMemory.new
        numbers.all.should eql([])
      end
    end
  end
end
