class Payment < ActiveRecord::Base
  attr_accessible :amount, :transaction_id, :transaction_provider
end
