
class ContributionsController < ApplicationController
  # GET /contributions
  # GET /contributions.json
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update]

  def index
    @contributions = Contribution.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contributions }
    end
  end

  # GET /contributions/1
  # GET /contributions/1.json
  def show
    @contribution = Contribution.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contribution }
    end
  end

  # GET /projects/1/contributions/new
  def new
    @project = Project.find_by_id params[:project_id]
    redirect_to projects_path, alert: "Invalid project" and return unless @project

    @reward = @project.rewards.find_by_id params[:reward_id] 
    if @reward.nil?
      flash.now.notice = "Please select your reward!" 
    end



    contrib_params = params[:contribution] || {}
    contrib_params[:reward_id] = @reward.id if @reward 
    contrib_params[:project_id] ||= @project.id
    contrib_params[:amount] ||= @reward?  @reward.minimum_contribution : 0
    session[:contrib_params] = contrib_params

    @contribution = @project.contributions.build(contrib_params)

  end


  def create
    # unless current_user_signed_in?
      # redirect_back_or sign_in_path, notice: "Please sign in first."
    # end
    @project = Project.find_by_id params[:project_id] 
    unless @project
      render action: "new", alert: "Something went wrong."
      return
    end
    contrib_params = session[:contrib_params] || {}
    contrib_params = contrib_params.with_indifferent_access
    contrib_params.merge! params[:contribution] if params[:contribution]
    contrib_params[:user] = current_user

    @contribution = @project.contributions.build contrib_params

    @payment = @contribution.build_payment amount: @contribution.amount, transaction_provider: 'AMAZON'
    @payment.caller_reference = @payment.id

    # create a new payment
    # redirect them to the amazon payment page
    if @contribution.save && @payment.save && @payment.update_attribute( :caller_reference, @payment.id)
      session[:contrib_params] = nil
      binding.pry
      redirect_to @payment.amazon_cbui_url(@contribution)
      # TODO(syu) --- what happen when this payment is abandoned? we should def not disiplay this notice then
      
      flash.notice = "Payment processed by Amazon."
      # redirect_to @contribution, notice: "Contribution created."
    else
      render action: "new" 
    end
  end

  def amazon_confirm_payment_callback
    @contribution = Contribution.find_by_id params[:contribution_id]
    @payment = Payment.find_by_caller_reference params[:callerReference]
    unless @contribution && @payment && @contribution.payment == @payment
      raise "EXCEPTION"
    end
    unless params[:status] == "SC"
      raise "EXCEPTION"
    end


    @payment.token_id = params[:tokenID]
    @payment.transaction_status = Payment::STATUS_CONFIRMED
    fps_pay_url = AmazonFPSUtils.get_fps_pay_url(@payment.caller_reference, @payment.amount, @payment.token_id)
    puts "fps_pay_url " + fps_pay_url
    response = RestClient.get fps_pay_url
    puts "response " + response
    pay_result_hash = Hash.from_xml(response)["PayResponse"]["PayResult"]
    @payment.transaction_id = pay_result_hash["TransactionId"]
    binding.pry

    payment_status = pay_result_hash["TransactionStatus"]
    while payment_status == "Pending"
      fps_status_url = AmazonFPSUtils.get_fps_get_transaction_status_url(@payment.caller_reference, @payment.transaction_id)
      binding.pry
      response = RestClient.get fps_status_url
      status_result_hash = Hash.from_xml(response)["GetTransactionStatusResponse"]["GetTransactionStatusResult"]
      payment_status = status_result_hash["TransactionStatus"]
      binding.pry
    end
    case payment_status
    when "Success"
      @payment.transaction_status = Payment::STATUS_SUCCESS
      @payment.save
      flash.now.notice = "Your payment was successfully received! Look out for an email from us."
      render @contribution.project
    when "Cancelled"
      @payment.transaction_status = Payment::STATUS_CANCELLED
      @payment.save
      flash.now.notice = "Looks like you changed your mind. If you reconsider, just go back to"
      render @contribution.project
    else  #failure
      @payment.transaction_status = Payment::STATUS_FAILURE
      @payment.save
      flash.now.notice = "Something went wrong. Please try again or contact info@communificiency.com"
      render @contribution.project
    end



   binding.pry
  end

  # PUT /contributions/1
  # PUT /contributions/1.json
=begin
  def update
    @contribution = Contribution.find(params[:id])

    respond_to do |format|
      if @contribution.update_attributes(params[:contribution])
        format.html { redirect_to @contribution, notice: 'Contribution was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contributions/1
  # DELETE /contributions/1.json
  def destroy
    @contribution = Contribution.find(params[:id])
    @contribution.destroy

    respond_to do |format|
      format.html { redirect_to contributions_url }
      format.json { head :no_content }
    end
  end
=end
end
