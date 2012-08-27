require 'digest'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # override existing evise valid_password
  alias :devise_valid_password? :valid_password?

  def valid_password?(password)
    begin
      super(password)
    rescue BCrypt::Errors::InvalidHash
      return false unless self.matches_password? password
      logger.info "User #{email} is using old password hashing method, updating attributes to use new password"
      self.password = password
      true
    end
  end

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :contributions
  has_many :projects, through: :contributions
  has_many :rewards, through: :contributions
  has_many :payments, through: :contributions
  has_many :proposed_projects, class_name: :project, inverse_of: :proposer



  # attr_accessor :password 
  ## TODO(SYU): understand where "password" is getting stored!
  # Notes: setting attr_accessor :email overrides the default :email attributes from the Rails model
  # Creating a class-level local variable is is just a local variable in the class scope -- not recognizable in any of the methods
  #
  attr_accessible :email, :name, :password, :password_confirmation

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true,
    length: {maximum: 40} 

  # validates :email,
    # presence: true,
    # format: { with: email_regex },
    # uniqueness: { case_sensitive: false }

  # validates :password, presence: true
  # validates :password, confirmation: true
  # validates :password, length: {within: 6..128}


  # validates :current_password, presence: {allow_nil: true, allow_blank: true}

  # validates :password_confirmation, presence: true
=begin

  before_save { |user| user.email.downcase! }
  before_save :generate_encrypted_password
=end


  def to_s
    self.name
  end

  def to_debug
    "User #{self.id}: #{self.name} #{self.email}"
  end

  def decorated_name
    glyph = admin? ? '^' : ''
    glyph << self.name 
  end

  def matches_password? submitted_password
    return User.encrypt(submitted_password, self.salt) == self.encrypted_password
  end

=begin

  def self.authenticate submitted_email, submitted_password
    user = User.find_by_email submitted_email
    (user && user.matches_password?(submitted_password)) ? user: nil 
    # if u.nil? || !u.matches_password?(submitted_password) 
    # return nil
    # end
    # return u
  end

  def self.authenticate_with_salt submitted_id, submitted_salt
    # Note: need find_by_id because find() on a nil throws an error where as find_by_id on nil returns nil
    user = User.find_by_id submitted_id
    (user && user.salt == submitted_salt) ? user : nil
    #if user.nil? || !user.salt == submitted_salt
    #return nil
    #end
    #return u
  end
=end

  private
  def generate_encrypted_password
    self.salt = Time.now.to_s if self.new_record?
    self.encrypted_password = User.encrypt(self.password, self.salt)
  end

  def self.encrypt password_string, salt_string 
    Digest::SHA2.hexdigest("#{password_string}--#{salt_string}")
  end

end
