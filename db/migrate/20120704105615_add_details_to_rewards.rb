class AddDetailsToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :minimum_contribution, :float
    add_column :rewards, :limited_quantity, :boolean
    add_column :rewards, :max_available, :integer
    add_column :rewards, :current_available, :integer
  end
end
