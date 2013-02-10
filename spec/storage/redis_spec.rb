require File.expand_path('../../../lib/moderation/storage/redis.rb', __FILE__)

describe Moderation::Storage::Redis do
  before(:each) do
    redis = Redis.new
    @redis = Redis::Namespace.new('moderation_test', redis)
    @redis.del 'test_data'
  end

  it 'initializes with a default limit of 25' do
    storage = Moderation::Storage::Redis.new(:collection => 'test_data', :server => @redis)
    storage.limit.should eql(25)
  end

  it 'accepts a custom limit' do
    storage = Moderation::Storage::Redis.new(:limit => 200, :collection => 'test_data', :server => @redis)
    storage.limit.should eql(200)
  end

  it 'accespts a new limit after initialization' do
    storage = Moderation::Storage::Redis.new(:limit => 200, :collection => 'test_data', :server => @redis)
    storage.limit = 135
    storage.limit.should eql(135)
  end

  it 'inserts data' do
    storage = Moderation::Storage::Redis.new(:collection => 'test_data', :server => @redis)
    storage.insert('a little bit of data')
    storage.all.should eql(['a little bit of data'])
  end

  it 'returns all data' do
    numbers = Moderation::Storage::Redis.new(:collection => 'test_data', :server => @redis)
    Array(0..10).each { |n|  numbers.insert(n) }
    numbers.all.should eql(["10", "9", "8", "7", "6", "5", "4", "3", "2", "1", "0"])
  end

  it 'returns a subset of data' do
    numbers = Moderation::Storage::Redis.new(:collection => 'test_data', :server => @redis)
    Array(0..10).each { |n|  numbers.insert(n) }
    numbers.all(:limit => 5).should eql(["10", "9", "8", "7", "6"])
  end

  it 'returns an empty Array' do
    numbers = Moderation::Storage::Redis.new(:collection => 'test_data', :server => @redis)
    numbers.all.should eql([])
  end

  it 'removes data outside of limit' do
    numbers = Moderation::Storage::Redis.new(:collection => 'test_data', :server => @redis, :limit => 5)
    Array(0..10).each { |n|  numbers.insert(n) }
    @redis.lrange('test_data', 0, -1).count.should eql(5)
  end
end

