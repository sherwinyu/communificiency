class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.authenticate(*params[:session].collect{ |k,v| v })
    if @user.nil?
      flash.now.alert = 'You entered an invalid email or password. Please try again'
      render 'new', layout: 'main_with_flash'
      # failure
    else
      flash.notice = 'Successfully logged in!' if Rails.env.development?
      sign_in @user
      redirect_to @user
      # success
      #
    end

  end

end
