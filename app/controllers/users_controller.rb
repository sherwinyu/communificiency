class UsersController < ApplicationController
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

end
