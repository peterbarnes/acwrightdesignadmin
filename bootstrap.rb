require 'rubygems'
require 'bundler'

Bundler.require

Dir["#{File.dirname(__FILE__)}/lib/**/*.rb"].each { |f| require(f) }

ENV['RACK_ENV'] ||= 'development'

if ENV['MONGOLAB_URI']
  uri = URI.parse(ENV['MONGOLAB_URI'])
  MongoMapper.connection = Mongo::Connection.new(uri.host, uri.port)
  MongoMapper.database = uri.path.gsub(/^\//, '')
  MongoMapper.database.authenticate(uri.user, uri.password)
else
  MongoMapper.connection = Mongo::Connection.new('localhost', 27017)
  MongoMapper.database = "acwrightdesign_#{ENV['RACK_ENV']}"
end