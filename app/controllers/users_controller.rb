class UsersController < ApplicationController
  def sign_up
    @user = User.new
    render 'sign_up', layout: "main_with_flash"
  end

  def show
    @user = User.find(params[:id])
    render layout: "main_with_flash"
  end

  def create
    redirect_to "/sign_up", layout: "main_with_flash" and return if params[:user].nil?

    #@user = User.new  name: params[:user][:name], email: params[:user][:email] 
    @user = User.new  params[:user]
    #@user.password = params[:user][:password]
    #@user.password_confirmation = params[:user][:password_confirmation] 
    if @user.save
      flash.notice = "Your profile was successfully created. Welcome to Communificiency!"
      redirect_to @user, layout: "main_with_flash"
    else
      render 'sign_up', layout: "main_with_flash"
    end
  end

end
