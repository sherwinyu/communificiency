class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update]

  def sign_up
    @user = User.new
    render 'sign_up'
  end

  def show
    @user = User.find(params[:id])
    render 
  end

  def create
    redirect_to "/sign_up" and return if params[:user].nil?

    @user = User.new  params[:user]

    if @user.save
      flash.notice = "Your profile was successfully created. Welcome to Communificiency!"
      sign_in @user
      redirect_to @user
    else
      render 'sign_up'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash.now.notice = 'Changes saved'
      sign_in @user
      render 'edit'
    else
      render 'edit'
    end
  end

  private
  def signed_in_user
    redirect_back_after sign_in_path, notice: "Please sign in first." unless current_user_signed_in?
  end

end
