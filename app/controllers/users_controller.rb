class UsersController < ApplicationController
  def sign_up
    @user = User.new
    render 'sign_up', layout: "main_with_flash"
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    redirect_to "/sign_up", layout: "main_with_flash" and return if params[:user].nil?

    @user = User.new  name: params[:user][:name], email: params[:user][:email] 
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation] 

    if @user.save
      flash.notice = "User successfully created!"
      redirect_to "/projects/1", layout: "main_with_flash"
    else
      flash.alert = "There were #{@user.errors.size} #{'errors'.pluralize(@user.errors.size)}"
      render 'sign_up', layout: "main_with_flash"
    end
  end

end
