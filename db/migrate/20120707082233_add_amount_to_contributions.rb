class AddAmountToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :amount, :float
  end
end
