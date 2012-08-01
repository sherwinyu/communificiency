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
    validates :transaction_status,
      presence: true,
      inclusion: { in: ALL_STATUSES }

    # Note: contribution amount / reward amount is only integer, but payment amount is float.
    validates :amount,
      numericality: true

    def amazon_cbui_url
        uri = URI.parse(AmazonFPSUtils.cbui_endpoint)
        cbui_params = AmazonFPSUtils.get_cbui_params( {"transactionamount" => self.amount,
                                                       "returnurl"=>  "#{Communificiency::Application.config.host_address}/confirm_payment_cbui",
                                                       "callerReference"=>  "#{self.id}",
                                                       "paymentReason"=> "Communificiency contribution" } )

        signature = SignatureUtils.sign_parameters({parameters: cbui_params, 
                                                    aws_secret_key: Communificiency::Application.config.aws_secret_key,
                                                    host: uri.host,
                                                    verb: AmazonFPSUtils.http_method,
                                                    uri: uri.path })

        cbui_params[SignatureUtils::SIGNATURE_KEYNAME] = signature
        cbui_url = AmazonFPSUtils.get_cbui_url(cbui_params)
        puts "\n\n\tCBUI!", cbui_url
        cbui_url
    end


    private
      def default_values
        if self.new_record?
          self.transaction_status = STATUS_CREATED
        end
      end

end
