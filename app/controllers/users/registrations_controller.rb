# References:
# 1. http://stackoverflow.com/questions/11002553/unknown-action-the-action-create-could-not-be-found-for-registrationscontroll
# 2. https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-on-successful-sign-up-%28registration%29
class Users::RegistrationsController < Devise::RegistrationsController

  # Overridden version
  def create
    build_resource

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with(resource) do |format|
        format.html { render file: "users/welcome", layout: "welcome_page_layout" }
      end
    end

  end

  protected

  def after_sign_up_path_for(resource)
    profile_edit_user_path(resource)
  end

end