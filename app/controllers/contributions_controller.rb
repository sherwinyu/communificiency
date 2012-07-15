
class ContributionsController < ApplicationController
  # GET /contributions
  # GET /contributions.json
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
    if !current_user_signed_in?
      flash.notice = "Please sign in first."
      redirect_to sign_in_path and return
    end

    @project = Project.find_by_id params[:project_id]
    redirect_to projects_path, alert: "project error" and return unless @project
    @reward = @project.rewards.find_by_id params[:reward_id] 
    if @reward.nil?
      flash.notice = "Please select your reward!" 
    end


    contrib_params = params[:contribution] || {}
    contrib_params[:user] = current_user
    contrib_params[:reward] = @reward # for both nil and non nil
    contrib_params[:amount] ||= @reward?  @reward.minimum_contribution : 0
    session[:contrib_params] = contrib_params

    @contribution = @project.contributions.build(contrib_params)

    binding.pry
  end


  def create
    @project = Project.find params[:project_id] 
    params[:contribution].merge! session[:contrib_params]
    @contribution = @project.contributions.build params[:contribution]
    
    # create a new payment
    # redirect them to the amazon payment page

    binding.pry
    if @contribution.save
      session[:contrib_params] = nil
      redirect_to @contribution.project, notice: "Contribution created."
    else
      render action: "new" 
    end
  end

  # PUT /contributions/1
  # PUT /contributions/1.json
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
end
