require 'rubygems'
require 'bundler/setup'

begin
  require 'pry'
rescue LoadError
end

require_relative '../lib/moderation'

RSpec.configure do |config|
end
