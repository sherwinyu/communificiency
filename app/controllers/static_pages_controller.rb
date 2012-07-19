class StaticPagesController < ApplicationController
  def home
    @title = 'Communificiency'
    @user_signup = UserSignup.new
    render layout: 'welcome'

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
end
