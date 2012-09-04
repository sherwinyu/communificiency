class ApplicationController < ActionController::Base

  protect_from_forgery
  include SessionsHelper

  # rescue_from ActionController::RoutingError, :with => :render_404
  # rescue_from ActionController::UnknownAction, :with => :render_404
  # rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  #
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: :render_500
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActionController::UnknownController, with: :render_404
    rescue_from ActionController::UnknownAction, with: :render_404
    rescue_from AbstractController::ActionNotFound, with: :render_500
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
  end

  before_filter :check_domain
  def check_domain
    if Rails.env.production? and request.host.downcase != 'communificiency.com'
      redirect_to request.protocol + 'communificiency.com' + request.fullpath, :status => 301
    end
  end


  def render_404 exception
    @not_found_path = exception.message
    respond_to do |format|
      format.html { render template: 'errors/error_404', layout: 'layouts/application', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end

  def render_500 exception
    @error = exception
    respond_to do |format|
      format.html { render template: 'errors/error_500', layout: 'layouts/application', status: 500 }
      format.all { render nothing: true, status: 500}
    end
  end

  def require_confirmed!
    link = '<a href="/users/confirmation/new">More information</a>'
    redirect_back_or home_path, notice: "Please confirm your email first. #{link}.".html_safe unless current_user.confirmed?
  end


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

  after_filter :store_location
  skip_after_filter :store_location, only: :create

  private
  def store_location
    session[:return_to] = request.fullpath
    puts "Location stored:" , session[:return_to] if Rails.env.development?
  end

  def clear_stored_location
    session[:return_to] = nil
  end

  def redirect_back_or(default, *args)
    redirect_to(session[:return_to] || default, *args)
    clear_stored_location
  end


end
