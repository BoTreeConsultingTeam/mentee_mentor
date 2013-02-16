class ResourcesController < ApplicationController

	before_filter :require_user
	
	def create      
  	resource = Resource.create(params[:resource])
    current_user.resources << resource
    #current_user.resources.create(params[:resource])
  end

end
