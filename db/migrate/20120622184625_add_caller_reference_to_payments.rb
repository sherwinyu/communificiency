class AddCallerReferenceToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :caller_reference, :string
  end
end
