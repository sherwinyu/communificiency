class StaticPagesController < ApplicationController
  def home
    @title = 'Communificiency'
  end

  def help
    @title = 'Help'
  end

  def about
    @title = 'About'
  end
end
