class ChangeLimitedQuantityToInteger < ActiveRecord::Migration
  def up
    change_column :rewards, :limited_quantity, :integer
    remove_column :rewards, :max_available
  end

  def down
    add_column :rewards, :max_available, :integer
    change_column :rewards, :limited_quantity, :boolean
  end
end
