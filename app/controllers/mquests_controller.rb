class MquestsController < ApplicationController

  before_filter :require_user

  # GET /users/:user_id/mquests
  def index
    # Show all users with links to request as Mentor or Mentee, except current
    # logged in user.
    @users = User.where("id != ?", current_user.id)
  end

  # As Mentor: /users/:mentor_id/mquest/:mentee_id/:role
  # As Mentee: /users/:mentee_id/mquest/:mentor_id/:role
  def create
    mentor_id = params[:mentor_id]
    mentee_id = params[:mentee_id]
    role = params[:role]

    if (role.present? and mentee_id.present? and mentor_id.present?)
      Rails.logger.info "Mentor Id: #{mentor_id}, Mentee Id: #{mentee_id}, Role: #{role}"
      redirect_to user_mquests_path(current_user)
    else
      redirect_to user_mquests_path(current_user), alert: t('user.mquests.errors.could_not_mquest')
    end
  end


end
