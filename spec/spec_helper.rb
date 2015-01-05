require 'rubygems'
require 'bundler/setup'

begin
  require 'pry'
rescue LoadError
end

require 'moderation'

require File.expand_path('../support/adapter.rb', __FILE__)
ENV['ADAPTER'] ||= 'memory'

RSpec.configure do |config|
end
