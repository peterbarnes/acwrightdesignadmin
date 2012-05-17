class Url
  include MongoMapper::Document
  timestamps!
  
  key :name,    String
  key :url,     String
  key :active,  Boolean,  :default => true
  
  belongs_to :creation
end