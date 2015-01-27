require 'spec_helper'
require 'mock_redis'

require_relative '../../../lib/moderation/adapters/redis_adapter'

module Moderation
  module Storage
    describe 'Redis' do
      context 'in redis storage' do
        let(:storage) do
          Adapters::RedisAdapter.new(options.merge({ name: 'test_data', server: redis }))
        end
        let(:redis)   { MockRedis.new }
        let(:options) {{ }}

        describe '#limit' do
          it 'initializes with a default limit of 25' do
            storage.limit.should eql(25)
          end

          context 'limit 200' do
            let(:options) {{ limit: 200 }}

            it 'accepts a custom limit' do
              storage.limit.should eql(200)
            end

            it 'accespts a new limit after initialization' do
              storage.limit = 135
              storage.limit.should eql(135)
            end
          end
        end

        describe '#insert' do
          let(:options) {{ limit: 5 }}

          it 'stores data' do
            storage.insert('a little bit of data')
            storage.all.should eql(["\"a little bit of data\""])
          end

          it 'removes data outside of limit' do
            Array(0..10).each { |n| storage.insert(n) }
            # binding.pry
            redis.lrange('moderation:test_data', 0, -1).count.should eql(5)
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
            Array(0..10).each { |n|  storage.insert(n) }
            storage.all.should eql(["10", "9", "8", "7", "6", "5", "4", "3", "2", "1", "0"])
          end

          it 'returns a subset of data' do
            Array(0..10).each { |n|  storage.insert(n) }
            storage.all(limit: 5).should eql(["10", "9", "8", "7", "6"])
          end

          it 'returns an empty Array with redis greater than 2.x' do
            redis.should_receive(:lrange).with('moderation:test_data', 0, 24).and_return([])
            storage.all.should eql([])
          end

          it 'returns an empty Array with redis 1.x' do
            redis.should_receive(:lrange).with('moderation:test_data', 0, 24).and_return(nil)
            storage.all.should eql([])
          end
        end

      end
    end
  end
end
