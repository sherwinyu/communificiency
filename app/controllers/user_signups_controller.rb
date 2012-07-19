class UserSignupsController < ApplicationController
  before_filter :require_admin, only: [:index]

  def create
    @user_signup = UserSignup.create( params[:user_signup] )
    if @user_signup.save
      redirect_to home_path, notice: "Successfully added to mailing list!"
    else
      render home_path, alert: "error"
    end
  end

  def index
    @user_signups = UserSignups.paginate( page: params[ :page ])
  end

end
