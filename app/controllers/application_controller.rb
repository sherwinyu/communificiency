class ApplicationController < ActionController::Base
  protect_from_forgery

  include 'sessions_controller'
end
