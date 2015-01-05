require 'spec_helper'

module Moderation
  describe Configuration do
    let(:configuration) { Configuration.new }

    describe '#default' do
      let(:limit) { 25 }

      it 'limit' do
        expect(configuration.limit).to eq(limit)
      end
    end
  end
end
