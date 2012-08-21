class AddStripeTokenToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :stripe_token, :string
  end
end
