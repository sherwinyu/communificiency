require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password 
  ## TODO(SYU): understand where "password" is getting stored!
  # Notes: setting attr_accessor :email overrides the default :email attributes from the Rails model
  # Creating a class-level local variable is is just a local variable in the class scope -- not recognizable in any of the methods
  #
  attr_accessible :email, :name, :password, :password_confirmation
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_presence_of :email 
  validates :email, format: {with: email_regex}
  validates :email, uniqueness: {case_sensitive: false} 

  validates :password, presence: true
  validates :password, confirmation: true
  validates :password, length: {within: 6..40}

  before_save :generate_encrypted_password

  def matches_password? submitted_password
    return User.encrypt(submitted_password, self.salt) == self.encrypted_password
  end

  def self.authenticate submitted_email, submitted_password
    user = User.find_by_email submitted_email
    (user && user.matches_password?(submitted_password)) ? user: nil 
    # if u.nil? || !u.matches_password?(submitted_password) 
      # return nil
    # end
    # return u
  end

  def self.authenticate_with_salt submitted_id, submitted_salt
    user = User.find submitted_id
    (user && user.salt == submitted_salt) ? user : nil
    #if user.nil? || !user.salt == submitted_salt
      #return nil
    #end
    #return u
  end

  private
  def generate_encrypted_password
    self.salt = Time.now.to_s if self.new_record?
    self.encrypted_password = User.encrypt(self.password, self.salt)
  end

  def self.encrypt password_string, salt_string 
    Digest::SHA2.hexdigest("#{password_string}--#{salt_string}")
  end

end
