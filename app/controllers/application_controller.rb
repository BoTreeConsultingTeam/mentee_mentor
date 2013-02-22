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

  def after_sign_up_path_for(resource)
    user_home_path
  end

  def valid_role?(role)
    %w(mentee mentor).include?(role)
  end

  # Applicable only when front-end renders a select box using
  # select_date helper
  def join_date_components_received_from_select_date_helper(date_hash)
    date_str = ''
    if date_hash.present?
      date = date_hash[:day]
      month = date_hash[:month]
      year = date_hash[:year]

      if (date.present? and month.present? and year.present?)
        date_str = "#{date}-#{month}-#{year}"
      end
    end
    date_str
  end

  private

  def require_user
    redirect_to root_path(token: params[:token]) unless user_signed_in?
  end

end
