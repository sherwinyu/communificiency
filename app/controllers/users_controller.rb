class UsersController < ApplicationController
  # before_filter :require_signed_in, only: [:edit, :update]
  # before_filter :require_correct_user, only: [:edit, :update]
  before_filter :authenticate_user!, only: [:edit, :update]

  def index
    @users = User.paginate( page: params[ :page ])
  end

  def show
    @user = User.find(params[:id])
    render 
  end


=begin

  def create
    @user = User.new params[:user]

    if @user.save
      # UserMailer.welcome_email(@user).deliver
      flash.notice = "Your profile was successfully created. Welcome to Communificiency!"
      sign_in @user
      redirect_to @user
    else
      render 'sign_up'
    end
  end
=end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    admin = params[:user].delete :admin
    @user.toggle :admin if admin && current_user_admin?
    # TODO(syu) log when non admins try to PUT with admin set to 1

    # TODO(syu) log update URL to be edit upon render (instead of /users/id)
    if @user.update_attributes(params[:user])
      flash.now.notice = 'Changes saved'
      sign_in @user
      render 'edit'
    else
      render 'edit'
    end
  end


  private


end
