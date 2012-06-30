class SessionsController < ApplicationController
  def new
  end

  def create
    u = User.authenticate(params[:email], params[:password])
    if u.nil?
      flash.alert = 'You entered an invalid email or password. Please try again'
      render 'new', layout: 'main_with_flash'
      # failure
    else
      # success
    end

  end

end
