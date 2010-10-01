require 'sqlite3'
require 'dm-core' 
require 'dm-migrations'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

#load models
Dir[File.join(File.dirname(__FILE__),'models', '*.rb')].each do |file| 
  require File.join(File.dirname(__FILE__),'models', File.basename(file, File.extname(file)))
end

DataMapper.auto_upgrade!

