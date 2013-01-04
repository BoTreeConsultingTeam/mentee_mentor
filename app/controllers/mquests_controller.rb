class MquestsController < ApplicationController

  before_filter :require_user

  # GET /users/:user_id/mquests
  def index
    # Show all users with links to request as Mentor or Mentee, except current
    # logged in user.
    @users = User.where("id != ?", current_user.id)
  end

  # POST /users/:from/mquest/:to/:role
  def create
    from_user_id = params[:from]
    to_user_id = params[:to]
    role = params[:role]

    message_hash = {}
    if (role.present? and from_user_id.present? and to_user_id.present?)
      mquest = Mquest.new(from_user: from_user_id, to_user: to_user_id, as_role: role)
      if mquest.save!

        message_args = { user_name: mquest.receiver.name, role: role }

        if mquest.send_notification
          message_hash[:notice] = t('user.mquests.messages.success', message_args)
        else
          message_hash[:notice] = t('user.mquests.messages.failure', message_args)
        end
      else
        message_hash[:alert] = t('user.mquests.errors.could_not_save_mquest')
      end
    else
      message_hash[:alert] = t('user.mquests.errors.could_not_mquest')
    end

    redirect_to user_mquests_path(current_user), flash: message_hash
  end

end
