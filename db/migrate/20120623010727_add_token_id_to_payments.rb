class AddTokenIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :token_id, :string
  end
end
