class User < ActiveRecord::Base
  attr_accessible :email, :name

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_presence_of :email 
  validates :email, format: {with: email_regex}
  validates :email, uniqueness: {case_sensitive: false} 
end
