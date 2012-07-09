module SessionsHelper
  # sets current_user to user
  def sign_in user
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token()
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user_signed_in?
    return !current_user.nil?
  end

  def sign_out 
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  private
  def user_from_remember_token 
    remember_token = cookies.signed[:remember_token]
    remember_token ||= [nil, nil]
    User.authenticate_with_salt(*remember_token)
  end


end
