class Payment < ActiveRecord::Base

  attr_accessible :amount, :transaction_id, :transaction_provider
  after_initialize :default_values

  has_one :contribution, inverse_of: :payment

  STATUS_CREATED = "payment created"
  STATUS_WAITING_CBUI = "waiting on user / amazon / cbui"
  STATUS_CONFIRMED = "amazon cbui confirmed"
  STATUS_PENDING = "amazon fps call made, payment pending"
  STATUS_SUCCESS = "payment succeeded"
  STATUS_CANCELLED = "payment cancelled"
  STATUS_FAILURE = "payment failed"

  ALL_STATUSES = [STATUS_CREATED, STATUS_WAITING_CBUI, STATUS_CONFIRMED, STATUS_PENDING, STATUS_SUCCESS, STATUS_CANCELLED, STATUS_FAILURE]
  AMAZON_FPS_TRANSACTION_STATUSES = ["Cancelled", "Failure", "Pending", "Reserved", "Success"]
  validates :transaction_status,
    presence: true,
    inclusion: { in: ALL_STATUSES }

  # Note: contribution amount / reward amount is only integer, but payment amount is float.
  validates :amount,
    numericality: true

  def amazon_cbui_url contribution
    uri = URI.parse(AmazonFPSUtils.cbui_endpoint)
    cbui_params = AmazonFPSUtils.get_cbui_params( {"transactionamount" => self.amount,
                                                   "returnurl"=>  "#{Communificiency::Application.config.host_address}/amazon_confirm_payment_callback/#{ (contribution && contribution.id) || 0}",
    "callerReference"=>  "#{self.id}",
    "paymentReason"=> "Communificiency contribution" } )

    signature = SignatureUtils.sign_parameters({parameters: cbui_params, 
                                                aws_secret_key: Communificiency::Application.config.aws_secret_key,
                                                host: uri.host,
                                                verb: AmazonFPSUtils.http_method,
                                                uri: uri.path })

    cbui_params[SignatureUtils::SIGNATURE_KEYNAME] = signature
    cbui_url = AmazonFPSUtils.get_cbui_url(cbui_params)
    cbui_url
  end

  def amazon_get_transaction_status_hash
    fps_status_url = AmazonFPSUtils.get_fps_get_transaction_status_url(self.caller_reference, self.transaction_id)
    # puts fps_status_url
    response = RestClient.get fps_status_url
    status_result_hash = Hash.from_xml(response)["GetTransactionStatusResponse"]["GetTransactionStatusResult"]
  end

  def amazon_poll_transaction_status
    status_result_hash = self.amazon_get_transaction_status_hash
    puts status_result_hash
    self.amazon_fps_transaction_status = status_result_hash["TransactionStatus"]
    self.amazon_fps_status_code = status_result_hash["StatusCode"]
  end

  def amazon_fps_pay
    fps_pay_url = AmazonFPSUtils.get_fps_pay_url(self.caller_reference, self.amount, self.token_id)
    puts "\tfps_pay_url " + fps_pay_url
    response = RestClient.get fps_pay_url
    pay_result_hash = Hash.from_xml(response)["PayResponse"]["PayResult"]
    puts "\tfps_pay response: " + pay_result_hash.inspect
    pay_result_hash
  end


  private
  def default_values
    if self.new_record?
      self.transaction_status = STATUS_CREATED
    end
  end

end
