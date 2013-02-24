module ApplicationHelper

  # Added for including Devise Sign-Up form directly inside a custom view.
  # instead of navigating to it through the Devise URL.
  # References:
  # 1) http://stackoverflow.com/questions/9381817/devise-sign-up-form-on-the-home-page-as-well
  # 2) https://github.com/plataformatec/devise/wiki/How-To:-def Display-a-custom-sign_in-form-anywhere-in-your-app(args)
  # 3) Devise gem codebase: Devise::RegistrationsController new action invoking its protected build_resource(hash=nil) method
  def resource_name
    devise_mapping.name
  end

  def resource
    @user ||= User.new_with_session({}, session)
  end

  # In this application SignUp and SignIn pages are both on a single page
  # thus using a single resource method affected both the SignUp and SignIn
  # forms when resource contained validation errors.Thus using a different
  # object for SignIn form using this method.
  def resource_for_signin
    @user_for_signin ||= User.new_with_session({}, session)
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

end
