class ResourcesController < ApplicationController

	before_filter :require_user
	
	# GET /users/:user_id/resources
  def index
  	# Fetch all users, except current logged in user.This is to allow a user to
    # follow another user in the system
    @users = User.where("id != ?", current_user.id)
  end
  
  def create
  		resource = Resource.create(params[:resource])
      if (!resource.nil?) 
        UserResource.create({:resource_id => resource.id,:user_id => current_user.id})
      else
        Rails.logger.debug "Resource errors found"
      end
  end

end
