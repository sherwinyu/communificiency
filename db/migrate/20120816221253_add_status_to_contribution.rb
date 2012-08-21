class AddStatusToContribution < ActiveRecord::Migration
  def change
    add_column :contributions, :status, :string
  end
end
