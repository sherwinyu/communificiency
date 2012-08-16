class AddAmazonFpsStatusToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :amazon_fps_status_code, :string
    add_column :payments, :amazon_fps_transaction_status, :string
  end
end
