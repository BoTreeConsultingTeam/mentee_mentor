class MquestsController < ApplicationController

  before_filter :require_user

  # GET /users/:user_id/mquests
  def index
    # Show all users with links to request as Mentor or Mentee, except current
    # logged in user.
    @users = User.where("id != ?", current_user.id)
  end

end
