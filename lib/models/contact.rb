class Contact
  include MongoMapper::Document
  timestamps!
  
  key :name,        String
  key :email,       String
  key :message,     String
  key :active,      Boolean,  :default => true
  
  validates_presence_of   :name, :email, :message
end