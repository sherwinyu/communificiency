class Project < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :short_description, :long_description, :video, :funding_needed, :proposer_name, :picture
  attr_accessible :rewards_attributes

  has_many :rewards, order: "minimum_contribution ASC", inverse_of: :project
  has_many :contributions, inverse_of: :project
  has_many :contributors, through: :contributions, source: :user
  belongs_to :proposer, class_name: :user, inverse_of: :proposed_projects

  accepts_nested_attributes_for :rewards, allow_destroy: true, reject_if: -> r  { r[:name].blank?}


  validates :name,
    uniqueness: true,
    presence: true,
    length: {maximum: 60}

  validates :short_description,
    presence: true,
    length: {maximum: 200, tokenizer: -> str { str.scan(/w+/) }, too_long: "must have at most %{count} words" }

  validates :long_description,
    presence: true

  validates :funding_needed,
    presence: true,
    numericality: {only_integer: true, greater_than: 0}

  validates_associated :rewards

  def to_s
    name
  end

end
