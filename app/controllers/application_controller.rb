class ApplicationController < ActionController::Base

  protect_from_forgery
  include SessionsHelper

  # rescue_from ActionController::RoutingError, :with => :render_404
  # rescue_from ActionController::UnknownAction, :with => :render_404
  # rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  def render_404
    if /(jpe?g|png|gif)/i === request.path
      render :text => "404 Not Found", :status => 404
    else
      render :template => "shared/404", :layout => 'application', :status => 404
    end
  end


  def require_confirmed!
    link = '<a href="/users/confirmation/new">More information</a>'
    redirect_back_or home_path, notice: "Please confirm your email first. #{link}.".html_safe unless current_user.confirmed?
  end

  after_filter :store_location

  def redirect_to(options = {}, response_status = {})
    ::Rails.logger.error("Redirected by #{caller(1).first rescue "unknown"}")
    super(options, response_status)
  end

  def redirect_back_after *args
    store_location
    redirect_to *args
  end

  def merge_params(p={})
    params.merge(p).delete_if{ |k,v| v.blank?}
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
