class UserSignup < ActiveRecord::Base
  attr_accessible :email
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: {message: " "}
  validates :email, format: {with: email_regex, message: "Please enter a valid email"}
  validates :email, uniqueness: {case_sensitive: false, message: "That email's already on our list!"} 
end
