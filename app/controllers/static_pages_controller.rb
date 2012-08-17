class StaticPagesController < ApplicationController
  def home
    @title = 'Communificiency'
    @user_signup = UserSignup.new
    render layout: 'welcome'
  end

  def coming_soon
    @user_signup = UserSignup.new

  end

  def help
    @title = 'Help'
  end

  def about
    @title = 'About'
  end

  def desc
  end

  def sign_up
    @title = 'Sign up'
  end

  def pay
    @title = 'Confirm contribution'
  end

  def error404
    render "errors/error_404"
  end

  def error500
    render "errors/error_500"
  end
end
