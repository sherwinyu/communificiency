module SessionsHelper

=begin
  # sets current_user to user
  def sign_in user
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def sign_out 
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def current_user
    @current_user ||= user_from_remember_token()
  end

=end
  def current_user_admin?
    current_user && current_user.admin?
  end
=begin

  def current_user=(user)
    @current_user = user
  end

  def current_user? ( user )
    user == current_user
  end

=end
  def current_user_signed_in?
    # return !current_user.nil?
    # use devise instead
    user_signed_in? 
  end
=begin

  def require_signed_in
    redirect_back_after sign_in_path, notice: "Please sign in first." unless current_user_signed_in?
  end

  def require_correct_user
    #TODO(syu) -- I don't think this will work.
    @user = User.find_by_id params[:id]
    redirect_back_or home_path, alert: "Insufficient privileges" unless current_user?(@user) or current_user_admin?
  end

  def require_admin
    if current_user && !current_user_admin?
      redirect_back_or home_path, alert: "Sorry, you don't have access to that."
    elsif !current_user_signed_in?
      redirect_back_after sign_in_path, alert: "Please sign in first." 
    end
  end



  private
  def user_from_remember_token 
    remember_token = cookies.signed[:remember_token]
    remember_token ||= [nil, nil]
    User.authenticate_with_salt(*remember_token)
  end
=end

end
