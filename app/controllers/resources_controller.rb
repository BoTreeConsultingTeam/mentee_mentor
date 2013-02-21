class ResourcesController < ApplicationController

	before_filter :require_user

    # POST /users/:id/resources
    def create
      resource = Resource.new(params[:resource])
      valid_resource = resource.valid?

      if valid_resource
        resource.save(validate: false)
        current_user.resources << resource
        flash[:notice] = t('user.resource.notices.success', content_type: resource.resource_type.capitalize)
      else
		flash[:notice] = t('user.resource.errors.user_friendly_message')
      end
      redirect_to mboard_user_path(current_user.id)
    end
end
