module SessionsHelper
  def sign_in user
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token()
    # return @current_user
    User.find_by_id(cookie.permanent.signed[:remember_token])
  end

  def current_user=(user)
    @current_user = user
  end

  def signed_in?
    return
  end

  private
  def user_from_remember_token 
    remember_token = cookies.signed[:remember_token]
    remember_token ||= [nil, nil]
    User.authenticate_with_salt(*remember_token)
  end


end
