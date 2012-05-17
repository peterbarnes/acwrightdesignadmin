class User
  include MongoMapper::Document
  timestamps!
  self.include_root_in_json = true
  
  key :username,        String,   :default => UUID.generate(:compact)
  key :password_hash,   String
  key :password_salt,   String
  key :first_name,      String
  key :last_name,       String
  key :active,          Boolean,  :default => true
  
  attr_accessor :password
  
  validates_presence_of     :first_name, :last_name
  validates_presence_of     :password, :on => :create
  validates_confirmation_of :password
  validates_inclusion_of    :active, :in => [true, false]
  validates_uniqueness_of   :username
  validates_format_of       :username,  :with => /\A[a-z0-9_]+\z/, 
                                        :message => "must contain only lowercase letters, numbers and underscores."
                                        
  before_save               :_encrypt_password
  
  def self.authenticate(username, password)
    user = self.first(:username => username, :active => true)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  private
  
  def _encrypt_password
    if self.password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(self.password, self.password_salt)
    end
  end
end