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

    

    cbui_params = {}
    cbui_params["callerkey"] = config.aws_access_key
    cbui_params["transactionamount"] = @payment.amount
    cbui_params["pipelinename"] = "SingleUse"
    cbui_params["returnurl"] = "#{config.host_address}/confirm_payment_cbui"
    cbui_params["version"] = AmazonFPSUtils.cbui_version
    #binding.pry
    cbui_params["callerReference"] = "ref#{Time.now.to_i}" # caller_reference unless caller_reference.nil?
    cbui_params["paymentReason"] = 'Communificiency' # payment_reason unless payment_reason.nil?
    cbui_params[SignatureUtils::SIGNATURE_VERSION_KEYNAME] = '2'
    cbui_params[SignatureUtils::SIGNATURE_METHOD_KEYNAME] = SignatureUtils::HMAC_SHA256_ALGORITHM
    uri = URI.parse(AmazonFPSUtils.cbui_endpoint)


    signature = SignatureUtils.sign_parameters({:parameters => cbui_params, 
                                                             :aws_secret_key => AmazonFPSUtils.secret_key,
                                                             :host => uri.host,
                                                             :verb => AmazonFPSUtils.http_method,
                                                             :uri  => uri.path })
    cbui_params[SignatureUtils::SIGNATURE_KEYNAME] = signature
    @cbui_url = AmazonFPSUtils.get_cbui_url(cbui_params)

    puts "\n\n\nCBUI!", @cbui_url

    redirect_to @cbui_url





    #respond_to do |format|
      #if @payment.save
        #format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
        #format.json { render json: @payment, status: :created, location: @payment }
      #else
        #format.html { render action: "new" }
        #format.json { render json: @payment.errors, status: :unprocessable_entity }
      #end
    #end
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
