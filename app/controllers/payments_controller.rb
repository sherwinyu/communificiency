#require 'signature_utils.rb'
#require 'signature_utils.rb'

class PaymentsController < ApplicationController
  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payments }
    end
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
    @payment = Payment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payment }
    end
  end

  # GET /payments/new
  # GET /payments/new.json
  def new
    @payment = Payment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment }
    end
  end

  # GET /payments/1/edit
  def edit
    @payment = Payment.find(params[:id])
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(params[:payment])
    @payment.save

    

    cbui_params = AmazonFPSUtils.get_cbui_params( {"transactionamount"=>@payment.amount,
                                                   "returnurl" => "#{Communificiency::Application.config.host_address}/confirm_payment_cbui",
                                                   "callerReference" => "#{@payment.id}",
                                                   "paymentReason" => "Communificiency contribution" } )

    #cbui_params["callerkey"] = config.aws_access_key
    #cbui_params["transactionamount"] = @payment.amount
    #cbui_params["pipelinename"] = "SingleUse"
    #cbui_params["returnurl"] = "#{config.host_address}/confirm_payment_cbui"
    #cbui_params["version"] = AmazonFPSUtils.cbui_version
    #cbui_params["callerReference"] = "ref#{Time.now.to_i}" # caller_reference unless caller_reference.nil?
    #cbui_params["paymentReason"] = 'Communificiency' # payment_reason unless payment_reason.nil?
    
    cbui_params[SignatureUtils::SIGNATURE_VERSION_KEYNAME] = '2'
    cbui_params[SignatureUtils::SIGNATURE_METHOD_KEYNAME] = SignatureUtils::HMAC_SHA256_ALGORITHM
    uri = URI.parse(AmazonFPSUtils.cbui_endpoint)

    signature = SignatureUtils.sign_parameters({:parameters => cbui_params, 
                                                             :aws_secret_key => Communificiency::Application.config.aws_secret_key,
                                                             :host => uri.host,
                                                             :verb => AmazonFPSUtils.http_method,
                                                             :uri  => uri.path })
    cbui_params[SignatureUtils::SIGNATURE_KEYNAME] = signature
    @cbui_url = AmazonFPSUtils.get_cbui_url(cbui_params)

    puts "\n\n\nCBUI!", @cbui_url
    @payment.transaction_status = Payment::STATUS_WAITING_CBUI
    @payment.save

    redirect_to @cbui_url
  end

def confirm_payment_cbui
  @payment = Payment.find params[:callerReference]

  if params[:status] == "SC" # if success
    @payment.token_id = params[:tokenID]
    @payment.transaction_status = Payment::STATUS_CREATED
    render text: 'success'
  else
    render text: 'fail'
  end

#tokenID"=>"667X81MSJ48CP31DJB6X5DPJ3ABWDKEED94P9NBFCVZV6XB22LHVSFPWKJHKT3G4",
 #"signatureMethod"=>"RSA-SHA1",
 #"status"=>"SC",
 #"signatureVersion"=>"2",
 #"signature"=>"L+tzg0X8QNaBanZ1uleR4kxRAKe3+1RNY2ytOKm8OAfOWp84YQ1n89bcYNEwbM/Z+kPh+Gc26str\nFtvpoFlqroV5Fo6EEj2jJBN07GVxIMTypOqnqU6vDgFTpCtmRBASh+jYR1QxcYSNCSPSeZKVXYo8\nfxl5q20yDF7JQgFvy1g=",
 #"certificateUrl"=>"https://fps.sandbox.amazonaws.com/certs/090911/PKICert.pem?requestId=1mkknc07lsywu0r27zwpwysz51zpdu7zvmxgabe6t5i3eqmqlu",
 #"expiry"=>"11/2012",
 #"callerReference"=>"ref#todo"}

   
end

  # PUT /payments/1
  # PUT /payments/1.json
  def update
    @payment = Payment.find(params[:id])

    respond_to do |format|
      if @payment.update_attributes(params[:payment])
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to payments_url }
      format.json { head :no_content }
    end
  end
end
