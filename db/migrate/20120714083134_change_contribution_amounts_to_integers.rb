class ChangeContributionAmountsToIntegers < ActiveRecord::Migration
  def up
      change_column :contributions, :amount, :integer
      change_column :rewards, :minimum_contribution, :integer
      change_column :projects, :funding_needed, :integer
  end

  def down
      change_column :contributions, :amount, :float
      change_column :rewards, :minimum_contribution, :float
      change_column :projects, :funding_needed, :float
  end
end
