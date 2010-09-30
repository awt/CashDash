class Chart
  include DataMapper::Resource
  property :name,           String,   :index => true, :key => true
  property :config,       Text
end
