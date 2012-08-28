include ActionView::Helpers::NumberHelper

class Reward < ActiveRecord::Base
  attr_accessible :long_description, :name, :project_id, :short_description, :minimum_contribution , :limited_quantity
  belongs_to :project, inverse_of: :rewards
  has_many :contributions, inverse_of: :reward

  validates :project,
    presence: true

  validates :limited_quantity, 
    numericality: {only_integer: true, greater_than: 0},
    allow_nil: true

  validates :minimum_contribution,
    presence: true,
    numericality: {only_integer: true, greater_than: 0}

  validates :name,
    presence: true,
    uniqueness: {scope: :project_id, unless: "project.nil?", message: "already exists for this project"},
    length: {maximum: 60}


  validates :short_description,
    presence: true,
    length: {maximum: 30, tokenizer: -> str { str.scan(/w+/) }, too_long: "must have at most %{count} words" }

  validates :long_description,
    presence: true

  def to_s
    # (name.blank? or minimum_contribution.to_f < 1) ? "New Reward" : "#{name}" + " ($%.2f)" % minimum_contribution
    (name.blank? or minimum_contribution.to_f < 1) ? "New reward" : "%s (%s)" % [self.name, self.minimum_contribution_dollars] 
  end

  def minimum_contribution_dollars
    number_to_currency(self.minimum_contribution, precision: 0)
  end

  def quantity_remaining
    if limited_quantity 
      [limited_quantity - self.contributions.size, 0].max
    else
      nil
    end
  end

  def limited_quantity?
    !!limited_quantity
  end

  def as_json(options={})
    super(methods: [:minimum_contribution_dollars, :limited_quantity?, :quantity_remaining] )
  end

end
