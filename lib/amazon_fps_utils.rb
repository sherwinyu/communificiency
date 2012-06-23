class AmazonFPSUtils
  class << self 
    attr_accessor :http_method, :cbui_version, :cbui_endpoint, :fps_version, :fps_endpoint
  end

  @http_method = "GET"
  @cbui_version = "2009-01-09"
  @cbui_endpoint = "https://authorize.payments-sandbox.amazon.com/cobranded-ui/actions/start"

  @fps_endpoint = "https://fps.sandbox.amazonaws.com/"
  @fps_version = "2008-09-17"

  def self.get_cbui_params(options )#amount, pipeline, caller_reference, payment_reason, return_url, signature_version, signature_method)
    params = {}
    params["callerKey"] = Communificiency::Application.config.aws_access_key
    params["pipelineName"] = "SingleUse"
    params["version"] = @cbui_version
    # params["callerReference"] = caller_reference unless caller_reference.nil?
    # params["paymentReason"] = payment_reason unless payment_reason.nil?
    params[SignatureUtils::SIGNATURE_VERSION_KEYNAME] = 2
    params[SignatureUtils::SIGNATURE_METHOD_KEYNAME] = SignatureUtils::HMAC_SHA256_ALGORITHM

    params.merge! options
    return params
  end

  def self.get_cbui_url(params)
    cbui_url = @cbui_endpoint + "?"

    isFirst = true
    params.each { |k,v|
      if(isFirst) then
        isFirst = false
      else
        cbui_url << '&'
      end

      cbui_url << SignatureUtils.urlencode(k)
      unless(v.nil?) then
        cbui_url << '='
        cbui_url << SignatureUtils.urlencode(v)
      end
    }
    return cbui_url
  end


  def self.test_cbui()
    uri = URI.parse(@@cbui_endpoint)
    params = get_cbui_params("1.1", "SingleUse", "YourCallerReference", "<paymentReason>", 
                             "#{HOST}/return", "2", SignatureUtils::HMAC_SHA256_ALGORITHM)


    signature = SignatureUtils.sign_parameters({:parameters => params, 
                                                :aws_secret_key => @@secret_key,
                                                :host => uri.host,
                                                :verb => @@http_method,
                                                :uri  => uri.path })
    params[SignatureUtils::SIGNATURE_KEYNAME] = signature
    get_cbui_url(params)
    # print get_cbui_url(params), "\n"
  end

  def self.get_fps_default_parameters()
    params = {}
    params["Version"] = @fps_version
    params["Timestamp"] = get_formatted_timestamp()
    params["AWSAccessKeyId"] = Communificiency::Application.config.aws_access_key
    params
  end

  def self.get_fps_url(params)
    fpsURL = @fps_endpoint + "?"
    isFirst = true
    params.each { |k,v|
      if(isFirst) then
        isFirst = false
      else
        fpsURL << '&'
      end

      fpsURL << SignatureUtils.urlencode(k)
      unless(v.nil?) then
        fpsURL << '='
        fpsURL << SignatureUtils.urlencode(v)
      end
    }
    fpsURL
  end 

  def self.get_formatted_timestamp()
    return Time.now.iso8601.to_s
  end

  def self.get_fps_pay_url(caller_reference, amount, sender_token_id)
    uri = URI.parse(@fps_endpoint)
    parameters = get_fps_default_parameters()
    parameters["Action"] = "Pay"
    parameters["CallerReference"] = caller_reference.to_s
    parameters["TransactionAmount.CurrencyCode"] = "USD"
    parameters["TransactionAmount.Value"] = amount.to_s
    parameters["SenderTokenId"] = sender_token_id.to_s
    parameters[SignatureUtils::SIGNATURE_VERSION_KEYNAME] = "2"
    parameters[SignatureUtils::SIGNATURE_METHOD_KEYNAME] = SignatureUtils::HMAC_SHA256_ALGORITHM
    signature = SignatureUtils.sign_parameters({:parameters => parameters, 
                                                :aws_secret_key => Communificiency::Application.config.aws_secret_key,
                                                :host => uri.host,
                                                :verb => @http_method,
                                                :uri  => uri.path })
    parameters[SignatureUtils::SIGNATURE_KEYNAME] = signature

    get_fps_url(parameters) 
  end

  def self.get_fps_get_transaction_status_url(caller_reference, transaction_id)
    uri = URI.parse(@fps_endpoint)
    parameters = get_fps_default_parameters()
    parameters["Action"] = "GetTransactionStatus"
    parameters["TransactionId"] = transaction_id
    parameters[SignatureUtils::SIGNATURE_VERSION_KEYNAME] = "2"
    parameters[SignatureUtils::SIGNATURE_METHOD_KEYNAME] = SignatureUtils::HMAC_SHA256_ALGORITHM
    signature = SignatureUtils.sign_parameters({:parameters => parameters, 
                                                :aws_secret_key => Communificiency::Application.config.aws_secret_key,
                                                :host => uri.host,
                                                :verb => @http_method,
                                                :uri  => uri.path })
    parameters[SignatureUtils::SIGNATURE_KEYNAME] = signature

    get_fps_url(parameters) 
  end

end
