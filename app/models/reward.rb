class Reward < ActiveRecord::Base
  attr_accessible :long_description, :name, :project_id, :short_description, :minimum_contribution, :limited_quantity 
  belongs_to :project, inverse_of: :rewards
  has_many :contributions, inverse_of: :reward

  validates_presence_of :minimum_contribution 
  validates_numericality_of :minimum_contribution, message: "has to be a number"

  validates :limited_quantity, 
    numericality: {only_integer: true, greater_than: 0},
    allow_nil: true

  validates :name,
    presence: true,
    uniqueness: { scope: :project_id, unless: "project.nil?"},
    length: {maximum: 60}


  validates :short_description,
    presence: true,
    length: {maximum: 30, tokenizer: -> str { str.scan(/w+/) }, too_long: "must have at most %{count} words" }

  validates :long_description,
    presence: true

  def to_s
    name.blank? ? "New Reward" : "#{name} ($%.2f)" % minimum_contribution
  end
end
