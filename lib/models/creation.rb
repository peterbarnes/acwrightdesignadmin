class Creation
  include MongoMapper::Document
  timestamps!
  
  key :name,        String
  key :thumbnail,   String
  key :description, String
  key :active,      Boolean,  :default => true
  
  validates_presence_of   :name
  
  many :urls
end