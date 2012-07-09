class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  after_filter :store_location

  def redirect_to(options = {}, response_status = {})
    ::Rails.logger.error("Redirected by #{caller(1).first rescue "unknown"}")
    super(options, response_status)
  end

  def redirect_back_after *args
    store_location
    redirect_to *args
  end

  private
    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_stored_location
      session[:return_to] = nil
    end

    def redirect_back_or(default, *args)
      redirect_to(session[:return_to] || default, *args)
      clear_stored_location
    end

end
