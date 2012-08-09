
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
