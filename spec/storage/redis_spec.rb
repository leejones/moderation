require File.expand_path('../../../lib/moderation/storage/redis.rb', __FILE__)

describe Moderation::Storage::Redis do
  let(:redis) do
    client = Redis.new
    client = Redis::Namespace.new('moderation_test', client)
    client.del 'test_data'
    client
  end

  describe '#limit' do
    it 'initializes with a default limit of 25' do
      storage = Moderation::Storage::Redis.new(:collection => 'test_data', :server => redis)
      storage.limit.should eql(25)
    end

    it 'accepts a custom limit' do
      storage = Moderation::Storage::Redis.new(:limit => 200, :collection => 'test_data', :server => redis)
      storage.limit.should eql(200)
    end

    it 'accespts a new limit after initialization' do
      storage = Moderation::Storage::Redis.new(:limit => 200, :collection => 'test_data', :server => redis)
      storage.limit = 135
      storage.limit.should eql(135)
    end
  end

  describe '#insert' do
    let(:storage) { Moderation::Storage::Redis.new(
      :collection => 'test_data',
      :server => redis,
      :limit => 5)
    }

    it 'stores data' do
      storage.insert('a little bit of data')
      storage.all.should eql(['a little bit of data'])
    end

    it 'removes data outside of limit' do
      Array(0..10).each { |n| storage.insert(n) }
      redis.lrange('test_data', 0, -1).count.should eql(5)
    end

    it 'uses a transaction with redis 2.x or greater' do
      redis.stub(:info).and_return({"redis_version" => "2.6.4"})
      redis.stub(:lpush)
      redis.stub(:ltrim)
      redis.should_receive(:multi).and_yield
      storage.insert('more data')
    end

    it 'does not use a transaction with redis 1.x' do
      redis.stub(:info).and_return({"redis_version" => "1.2.0"})
      redis.stub(:lpush)
      redis.stub(:ltrim)
      redis.should_not_receive(:multi)
      storage.insert('more data')
    end
  end

  describe '#all' do
    it 'returns all data' do
      numbers = Moderation::Storage::Redis.new(:collection => 'test_data', :server => redis)
      Array(0..10).each { |n|  numbers.insert(n) }
      numbers.all.should eql(["10", "9", "8", "7", "6", "5", "4", "3", "2", "1", "0"])
    end

    it 'returns a subset of data' do
      numbers = Moderation::Storage::Redis.new(:collection => 'test_data', :server => redis)
      Array(0..10).each { |n|  numbers.insert(n) }
      numbers.all(:limit => 5).should eql(["10", "9", "8", "7", "6"])
    end

    it 'returns an empty Array with redis greater than 2.x' do
      redis.should_receive(:lrange).with('test_data', 0, 24).and_return([])
      numbers = Moderation::Storage::Redis.new(:collection => 'test_data', :server => redis)
      numbers.all.should eql([])
    end

    it 'returns an empty Array with redis 1.x' do
      redis.should_receive(:lrange).with('test_data', 0, 24).and_return(nil)
      numbers = Moderation::Storage::Redis.new(:collection => 'test_data', :server => redis)
      numbers.all.should eql([])
    end
  end
end

