require File.expand_path('../../../lib/moderation/storage/in_memory.rb', __FILE__)

describe Moderation::Storage::InMemory do
  it 'initializes with a default limit of 25' do
    storage = Moderation::Storage::InMemory.new
    storage.limit.should eql(25)
  end

  it 'accepts a custom limit of 200' do
    storage = Moderation::Storage::InMemory.new(200)
    storage.limit.should eql(200)
  end

  it 'inserts data' do
    storage = Moderation::Storage::InMemory.new
    storage.insert('treadstone')
    storage.all.should eql(['treadstone'])
  end

  it 'returns all data' do
    numbers = Moderation::Storage::InMemory.new
    Array(0..10).each { |n|  numbers.insert(n) }
    numbers.all.should eql([10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0])
  end

  it 'returns a subset of data' do
    numbers = Moderation::Storage::InMemory.new
    Array(0..10).each { |n|  numbers.insert(n) }
    numbers.all(:limit => 5).should eql([10, 9, 8, 7, 6])
  end

  it 'returns an empty Array' do
    numbers = Moderation::Storage::InMemory.new
    numbers.all.should eql([])
  end
end

