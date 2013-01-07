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
      if valid_role?(role)
        mquest = Mquest.new(from_user: from_user_id, to_user: to_user_id, as_role: role)
        if mquest.save!
          message_args = { user_name: mquest.receiver.name, role: role }

          # If email settings are unavailable, then directly create the
          # mentor-mentee connection
          mail_settings_available = Settings.try(:mail_settings_available)
          if (!mail_settings_available.nil? and !mail_settings_available)
            Rails.logger.info "MAIL SETTINGS ARE UNAVAILABLE.DIRECTLY CONNECTING THE USERS INVOLVED IN MQUEST."
            create_mentor_mentee_connection(mquest)

            # Ignore the message returned by create_mentor_mentee_connection(mquest) method
            # It returns success message in context of who mquest receiver accepting
            # the mquest.And for immediate linking the message should be in context
            # of current logged in user.
            message = t('user.mentor_mentee_connection.messages.success', { role: mquest.as_role, user_name: mquest.receiver.name })

            redirect_to user_mquests_path(current_user), flash: { notice: message }
            return
          else
            Rails.logger.info "mail_settings_available variable under /config/settings.yml unavailable or set to true."
            Rails.logger.info "mail_settings_available --> #{mail_settings_available}"
          end

          if mquest.send_notification
            message_hash[:notice] = t('user.mquests.messages.success', message_args)
          else
            message_hash[:notice] = t('user.mquests.messages.failure', message_args)
          end
        else
          message_hash[:alert] = t('user.mquests.errors.could_not_save_mquest')
        end
      else
        message_hash[:alert] = t('user.mquests.errors.invalid_role', { role: role } )
      end
    else
      message_hash[:alert] = t('user.mquests.errors.could_not_mquest')
    end

    redirect_to user_mquests_path(current_user), flash: message_hash
  end

  # GET /mquests/:token/accept
  def accept
    token = params[:token]
    if token.present?
      mquest = Mquest.where(token: token).first

      # Check if Mquest record found for received token?
      if mquest.nil?
        message = t('user.mquests.errors.mquest_token_invalid')
        Rails.logger.debug message
        redirect_to user_mquests_path(current_user), flash: { error: message }
        return
      else
        mquest_receiver = mquest.receiver
        # Check whether the logged in user is authorized to accept the mquest?
        if (mquest.receiver.id != current_user.id)
          message = t('user.mquests.errors.unauthorized_mquest_accept_request')
          Rails.logger.debug message
          redirect_to user_mquests_path(current_user), flash: { error: message }
          return
        else
          message = create_mentor_mentee_connection(mquest)
          redirect_to user_mquests_path(current_user), flash: { notice: message }
        end
      end
    else
      message = t('user.mquests.errors.mquest_token_not_received')
      Rails.logger.debug message
      redirect_to user_mquests_path(current_user), flash: { error: message }
    end
  end

  private

  def create_mentor_mentee_connection(mquest)
    # Process the Mquest accept:
    # 1. Create MentorMenteeConnection
    # 2. Delete the Mquest
    mquest_sender = mquest.sender
    mquest_receiver = mquest.receiver
    as_role = mquest.as_role

    args = case as_role
            when Mquest::MENTOR
              { mentor_id: mquest_sender.id, mentee_id: mquest_receiver.id }
            when Mquest::MENTEE
              { mentee_id: mquest_sender.id, mentor_id: mquest_receiver.id }
           end

    role_for_message = case as_role
                        when Mquest::MENTOR
                          Mquest::MENTEE
                        when Mquest::MENTEE
                          Mquest::MENTOR
                       end

    mentor_mentee_connection = MentorMenteeConnection.create(args)
    if mentor_mentee_connection.nil?
      message = t('user.mentor_mentee_connection.messages.failure', { role: role_for_message, user_name: mquest_sender.name })
    else
      mquest.delete # Delete the Mquest
      # Once the Mentor-Mentee connection is linked, all Mquest requests
      # involving the connected users pair should be removed.At a time
      # only one connection is supported.Cyclic links are unsupported.
      mentor_id = mentor_mentee_connection.mentor_id
      mentee_id = mentor_mentee_connection.mentee_id
      arr = [mentor_id, mentee_id]
      Mquest.where(from_user: arr, to_user: arr).delete_all
      message = t('user.mentor_mentee_connection.messages.success', { role: role_for_message, user_name: mquest_sender.name })
    end
    message
  end

end
