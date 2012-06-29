
class UsersController < ApplicationController
  def sign_up
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    u = User.new params[:user]
    if u.save
      flash.notice = "User successfully created!"
      redirect_to "/", layout: "main_with_flash"
    else
      flash.alert = "There were #{u.errors.size} #{'errors'.pluralize(u.errors.size)}"
      render "/users/sign_up", layout: "main_with_flash"
    end
  end

end
