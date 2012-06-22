class AmazonFPSUtils
  class << self 
    attr_accessor :access_key, :secret_key, :cbui_version, :http_method, :cbui_endpoint
  end

  @access_key = 'AKIAI5RRHRFM2GH67ORA'
  @secret_key = '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'
  @cbui_version = "2009-01-09"
  @http_method = "GET"
  @host = "http://localhost:8000"
  @cbui_endpoint = "https://authorize.payments-sandbox.amazon.com/cobranded-ui/actions/start"

  def self.get_cbui_params(amount, pipeline, caller_reference, payment_reason, return_url, signature_version, signature_method)
    params = {}
    params["callerKey"] = @@access_key
    params["transactionAmount"] = amount
    params["pipelineName"] = pipeline
    params["returnUrl"] = return_url
    params["version"] = @@cbui_version
    params["callerReference"] = caller_reference unless caller_reference.nil?
    params["paymentReason"] = payment_reason unless payment_reason.nil?
    if (signature_version.nil?) then
      params[SignatureUtils::SIGNATURE_VERSION_KEYNAME] = "1"
    else
      params[SignatureUtils::SIGNATURE_VERSION_KEYNAME] = signature_version
    end
    params[SignatureUtils::SIGNATURE_METHOD_KEYNAME] = signature_method unless signature_method.nil?

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
                             "#{HOST}/return", "2", SignatureUtils::HMAC_SHA256_ALGORITHM);


    signature = SignatureUtils.sign_parameters({:parameters => params, 
                                                             :aws_secret_key => @@secret_key,
                                                             :host => uri.host,
                                                             :verb => @@http_method,
                                                             :uri  => uri.path })
    params[SignatureUtils::SIGNATURE_KEYNAME] = signature
    get_cbui_url(params)
    # print get_cbui_url(params), "\n"
  end
end
