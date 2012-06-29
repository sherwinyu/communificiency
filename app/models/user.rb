class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :email, :name, :password, :password_confirmation

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_presence_of :email 
  validates :email, format: {with: email_regex}
  validates :email, uniqueness: {case_sensitive: false} 

  validates :password, presence: true
  validates :password, confirmation: true
  validates :password, length: {within: 6..40}

  before_save :encrypt_password

  def matches_password? submitted_password
    return User.encrypt(submitted_password) == self.encrypted_password
  end

  private
  def encrypt_password
    self.encrypted_password = User.encrypt(self.password)
  end

  def self.encrypt s
    s
  end

end
