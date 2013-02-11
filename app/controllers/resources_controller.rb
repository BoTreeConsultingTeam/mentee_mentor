class ResourcesController < ApplicationController

	before_filter :require_user

	# GET /users/:user_id/mquests
  def index
  end
  
  def create
  		#@list = current_user.resources.create(params[:resource])
  end

end
