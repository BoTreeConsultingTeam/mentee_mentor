class ApplicationController < ActionController::Base
  protect_from_forgery

  # Reference: https://github.com/plataformatec/devise/wiki/How-to:-redirect-to-a-specific-page-on-successful-sign-in-and-sign-out
  def after_sign_in_path_for(resource)
     user_home_path
  end

  # Reference: http://railsforum.com/viewtopic.php?id=36667
  def is_email?(str)
    return false if str.blank?

    email_regex = %r{
      ^ # Start of string
      [0-9a-z] # First character
      [0-9a-z.+]+ # Middle characters
      [0-9a-z] # Last character
      @ # Separating @ character
      [0-9a-z] # Domain name begin
      [0-9a-z.-]+ # Domain name middle
      [0-9a-z] # Domain name end
      $ # End of string
    }xi # Case insensitive

    !str[email_regex].nil?
  end

  private

  def require_user
    redirect_to root_path unless user_signed_in?
  end

end
