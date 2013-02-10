class ResourcesController < ApplicationController

	before_filter :require_user

	# GET /users/:user_id/mquests
  def index
    # Show all users with links to request as Mentor or Mentee, except current
    # logged in user.
    @users = User.where("id != ?", current_user.id)
  end
  
  def create
  		@list = current_user.resources.create(params[:resource])
  end

end
