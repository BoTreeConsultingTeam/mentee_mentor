require 'mentor_mentee_helpers/auth/external_provider'

# Reference: https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  include MentorMenteeHelpers::Auth::ExternalProvider

  # The callback should be implemented as an action with the same name as the
  # provider.Its required by Devise to work in a correct manner.
  def linkedin
    handle_callback(:linkedin)
  end

  def disconnect
    handle_disconnect(params[:provider])
  end

end
