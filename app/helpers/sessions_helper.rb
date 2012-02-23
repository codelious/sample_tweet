module SessionsHelper
  
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    current_user = user
  end
end
