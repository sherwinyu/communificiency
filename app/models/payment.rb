class Payment < ActiveRecord::Base
  attr_accessible :amount, :transaction_id, :transaction_provider
  after_initialize :default_values

    STATUS_CREATED = "payment created"
    STATUS_WAITING_CBUI = "waiting on user / amazon / cbui"
    STATUS_CONFIRMED = "amazon cbui confirmed"
    STATUS_PENDING = "amazon fps call made, payment pending"
    STATUS_SUCCESS = "payment succeeded"
    STATUS_CANCELLED = "payment cancelled or other error"

    ALL_STATUSES = [STATUS_CREATED, STATUS_WAITING_CBUI, STATUS_CONFIRMED, STATUS_PENDING, STATUS_SUCCESS, STATUS_CANCELLED]
    validates_inclusion_of :transaction_status, :in => ALL_STATUSES

    private
      def default_values
        if self.new_record?
          self.transaction_status = STATUS_CREATED
        end
      end

end
