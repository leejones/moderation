require 'spec_helper'

require 'rails/generators'
require 'ammeter/init'

# Generators are not automatically loaded by Rails
require_relative '../../../lib/generators/moderation/install/install_generator'

module Moderation
  module Generators
    describe InstallGenerator do
      # Tell the generator where to put its output (what it thinks of as Rails.root)
      destination File.expand_path('../../../../tmp', __FILE__)

      before do
        prepare_destination
      end

      after do
        FileUtils.rm_rf destination_root
      end

      describe 'the generated files' do
        before do
          run_generator
        end

        describe 'the spec' do
          let(:file_path) { 'config/initializers/moderation.rb' }

          subject { file(file_path) }

          specify do
            expect(File.exists?("#{destination_root}/#{file_path}")).to be_truthy
          end
        end
      end
    end
  end
end
