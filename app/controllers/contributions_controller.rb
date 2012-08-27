
class ContributionsController < ApplicationController
  # GET /contributions
  # GET /contributions.json
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update]
  before_filter :require_confirmed!, only: [:new, :create, :edit, :update]
  before_filter :require_admin!, only: [:index, :show]

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



    contrib_params = params[:contribution] || {}
    contrib_params[:reward_id] = @reward.id if @reward 
    contrib_params[:project_id] ||= @project.id
    contrib_params[:amount] ||= @reward?  @reward.minimum_contribution : 0
    session[:contrib_params] = contrib_params

    @contribution = @project.contributions.build(contrib_params)
  end

  skip_after_filter :store_location, only: :create
  def create
    puts params
    @project = Project.find_by_id params[:project_id] 
    unless @project
      render action: "new", alert: "Something went wrong. Please try again."
      return
    end

    provider = params[:contribution].delete :payment_transaction_provider

    contrib_params = (session[:contrib_params] || {}).with_indifferent_access
    contrib_params.merge! params[:contribution] if params[:contribution]
    contrib_params[:user] = current_user

    @contribution = @project.contributions.build contrib_params
    @payment = @contribution.build_payment amount: @contribution.amount


    unless @contribution.save && @payment.save
      flash.alert = "There were some problems. Please try again." 
      render 'new' and return
    end

    case provider
    when "AMAZON"
      @payment.caller_reference = @payment.id
      if @payment.update_attribute( :caller_reference, @payment.id)
        session[:contrib_params] = nil
        redirect_to @payment.amazon_cbui_url(@contribution)
        # TODO(syu) --- what happen when this payment is abandoned? we should def not disiplay this notice then

        # flash.notice = "Payment processed by Amazon."
        # redirect_to @contribution, notice: "Contribution created."
      else
        render action: "new" 
      end

    when "STRIPE"
      begin
        @payment.stripe_pay! params[:stripeToken]
      rescue => e
        flash.alert = "There was a problem: #{e.message}. Please check everything and try again."
        redirect_to new_project_contribution_path(@project) and return
      end

      flash.notice = "Your contribution to #{@project.name} for $#{@contribution.amount} was successfully received! Look out for an email from us for details of your reward within the day. Thanks!"
      UserMailer.contribution_confirmation(@contribution).deliver
      redirect_to @project
    end
  end


  def amazon_confirm_payment_callback
    @contribution = Contribution.find_by_id params[:contribution_id]
    @payment = Payment.find_by_caller_reference params[:callerReference]
    @project = @contribution.project
    begin
      unless @contribution && @payment && @contribution.payment == @payment
        raise "payment and contribution mismatch"
      end
      unless params[:status] == "SC"
        raise "amazon cbui call was not successful: " + params
      end

      @payment.token_id = params[:tokenID]
      @payment.transaction_status = Payment::STATUS_CONFIRMED

      begin
        pay_result_hash = @payment.amazon_fps_pay
        @payment.transaction_id = pay_result_hash["TransactionId"]
        @payment.amazon_fps_transaction_status = pay_result_hash["TransactionStatus"]
      rescue => e
        puts "error rest client: ", e.inspect, e.backtrace 
        raise e, "rest client error"
      end

      while @payment.amazon_fps_transaction_status == "Pending"
        @payment.amazon_poll_transaction_status
      end

      case @payment.amazon_fps_transaction_status
      when "Success"
        @payment.transaction_status = Payment::STATUS_SUCCESS
        @payment.save
        flash.notice = "Your contribution to #{@project.name} for $#{@contribution.amount} was successfully received! Look out for an email from us for details of your reward within the day. Thanks!"
        redirect_to project_path( @contribution.project ) and return
      when "Cancelled"
        @payment.transaction_status = Payment::STATUS_CANCELLED
        @payment.save
        flash.alert = "Looks like you changed your mind. If you reconsider, just go back to"
        redirect_to project_path( @contribution.project ) and return
      else  #failure
        @payment.transaction_status = Payment::STATUS_FAILURE
        @payment.save
        puts "payment failure"
        raise "payment failure"
      end
    rescue => e
      puts e, "error in amazon_confirm_payment_callback", e.backtrace
      flash.alert = "Something went wrong. Please try again or contact team@communificiency.com"
      redirect_to new_project_contribution_path(@contribution.project || 1)
    end



  end

  def require_confirmed!
    link = '<a href="/users/confirmation/new">More information</a>'
    redirect_to projects_path, notice: "Please confirm your email first. #{link}.".html_safe unless current_user.confirmed?
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
