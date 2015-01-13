require 'spec_helper'

require_relative '../../../lib/moderation/adapters/memory_adapter'

module Moderation
  module Storage
    describe 'InMemory' do
      context 'in memory storage' do
        let(:storage) { Adapters::MemoryAdapter.new(options) }
        let(:options) {{  }}

        it 'initializes with a default limit of 25' do
          storage.limit.should eql(25)
        end

        context 'limit 200' do
          let(:options) {{ limit: 200 }}

          it 'accepts a custom limit of 200' do
            storage.limit.should eql(200)
          end

          it 'accepts a new limit' do
            storage.limit = 100
            storage.limit.should eql(100)
          end
        end

        it 'inserts data' do
          storage.insert('treadstone')
          storage.all.should eql(["\"treadstone\""])
        end

        it 'returns all data' do
          Array(0..10).each { |n| storage.insert(n) }
          storage.all.should eql(["10", "9", "8", "7", "6", "5", "4", "3", "2", "1", "0"])
        end

        it 'returns a subset of data' do
          Array(0..10).each { |n| storage.insert(n) }
          storage.all(limit: 5).should eql(["10", "9", "8", "7", "6"])
        end

        it 'returns an empty Array' do
          storage.all.should eql([])
        end
      end
    end
  end
end
