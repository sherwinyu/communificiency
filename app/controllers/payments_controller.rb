#require 'signature_utils.rb'
#require 'signature_utils.rb'

class PaymentsController < ApplicationController
  before_filter :require_admin, only: [:new, :create, :edit, :update, :destroy]
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
    @payment.caller_reference = @payment.id





    # cbui_params = AmazonFPSUtils.get_cbui_params( {"transactionamount": @payment.amount,
                                                   # "returnurl":  "#{Communificiency::Application.config.host_address}/confirm_payment_cbui",
                                                   # "callerReference":  "#{@payment.id}",
                                                   # "paymentReason": "Communificiency contribution" } )

    #cbui_params["callerkey"] = config.aws_access_key
    #cbui_params["transactionamount"] = @payment.amount
    #cbui_params["pipelinename"] = "SingleUse"
    #cbui_params["returnurl"] = "#{config.host_address}/confirm_payment_cbui"
    #cbui_params["version"] = AmazonFPSUtils.cbui_version
    #cbui_params["callerReference"] = "ref#{Time.now.to_i}" # caller_reference unless caller_reference.nil?
    #cbui_params["paymentReason"] = 'Communificiency' # payment_reason unless payment_reason.nil?

    uri = URI.parse(AmazonFPSUtils.cbui_endpoint)

    signature = SignatureUtils.sign_parameters({parameters: cbui_params, 
                                                aws_secret_key: Communificiency::Application.config.aws_secret_key,
                                                host: uri.host,
                                                verb: AmazonFPSUtils.http_method,
                                                uri: uri.path })
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
      @payment.transaction_status = Payment::STATUS_CONFIRMED

      fps_pay_url = AmazonFPSUtils.get_fps_pay_url(@payment.caller_reference, @payment.amount, @payment.token_id)
      response = RestClient.get fps_pay_url
      pay_result_hash = Hash.from_xml(response)["PayResponse"]["PayResult"]
      @payment.transaction_id = pay_result_hash["TransactionId"]

      status = pay_result_hash["TransactionStatus"]
      while status == "Pending"
        fps_status_url = AmazonFPSUtils.get_fps_get_transaction_status_url(@payment.caller_reference, @payment.transaction_id)
        response = RestClient.get fps_status_url
        status_result_hash = Hash.from_xml(response)["GetTransactionStatusResponse"]["GetTransactionStatusResult"]
        status = status_result_hash["TransactionStatus"]
        p "status is #{status}"
        # status = Hash.from_xml(RestClient.get fps_pay_url)["PayResponse"]["PayResult"]
      end

      if status == "Success"
        @payment.transaction_status = Payment::STATUS_SUCCESS
        @payment.save
        flash.now.notice = "Your payment was successfully received! Look out for an email from us."
        render 'static_pages/desc/'
      elsif status == "Cancelled"
        @payment.transaction_status = Payment::STATUS_CANCELLED
        @payment.save
        flash.now.notice = "Looks like you changed your mind. If you reconsider, just go back to"
        render 'static_pages/desc/'
      else
        @payment.transaction_status = Payment::STATUS_FAILURE
        @payment.save
        flash.now.notice = "Something went wrong. Please try again or contact info@communificiency.com"
        render 'static_pages/desc/'
      end
    else 
      @payment.transaction_status = Payment::STATUS_FAILURE
      @payment.save
      flash.now.notice = "Something went wrong. Please try again or contact info@communificiency.com"
      render 'static_pages/desc/'
    end
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
