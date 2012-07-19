class ChangeLimitedQuantityToInteger < ActiveRecord::Migration
  def up
    remove_column :rewards, :max_available
    remove_column :rewards, :limited_quantity
    add_column :rewards, :limited_quantity, :integer
  end

  def down
    add_column :rewards, :max_available, :integer
    remove_column :rewards, :limited_quantity 
    add_column :rewards, :limited_quantity, :boolean
  end
end
