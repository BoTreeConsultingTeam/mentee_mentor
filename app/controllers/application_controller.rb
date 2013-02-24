class ApplicationController < ActionController::Base
  protect_from_forgery

  # Reference: https://github.com/plataformatec/devise/wiki/How-to:-redirect-to-a-specific-page-on-successful-sign-in-and-sign-out
  def after_sign_in_path_for(resource)
    if params[:user][:mquest_token].present?
      accept_mquest_path(token: params[:user][:mquest_token])
    else
      user_home_path
    end
  end

  private

  def require_user
    redirect_to root_path(token: params[:token]) unless user_signed_in?
  end

end
