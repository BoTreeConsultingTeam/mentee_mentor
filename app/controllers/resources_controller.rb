class ResourcesController < ApplicationController

	before_filter :require_user

    #POST /users/:id/resources
	def create
      user_resource_obj = current_user.resources.create(params[:resource])
      if user_resource_obj.nil?
        message = t('user.resource.errors.failure')
      else
        message = t('user.resource.errors.success')
      end
      Rails.logger.debug message
      redirect_to mboard_user_path(current_user.id), flash: { error: message }
  end

end
