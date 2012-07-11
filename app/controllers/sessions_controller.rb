class SessionsController < ApplicationController
  skip_after_filter :store_location

  def new
  end

  # "/sign_in"
  def create
    @user = User.authenticate(*params[:session].collect{ |k,v| v })
    if @user.nil?
      flash.now.alert = 'You entered an invalid email or password. Please try again'
      render 'new'
    else
      flash.notice = 'Successfully logged in!' if Rails.env.development?
      sign_in @user
      redirect_back_or @user 
      # success
    end

  end

  # "/sign_out"
  def destroy
    flash.notice = 'Signed out'
    sign_out
    redirect_to home_path
  end

end
