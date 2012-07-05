class Project < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :short_description, :long_description, :video, :funding_needed, :proposer_name, :picture
  attr_accessible :rewards_attributes
  has_many :rewards
  has_many :contributions
  accepts_nested_attributes_for :rewards, allow_destroy: true

  def to_s
    name
  end

end
