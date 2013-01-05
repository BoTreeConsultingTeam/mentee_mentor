class UsersController < ApplicationController

  before_filter :require_user, except: [:welcome]

  before_filter :fetch_user, only: [:show, :edit, :update]
  # before_filter :build_profile, only: [:show, :edit, :update]

  def welcome
    # On the welcome page itself Sign Up page is rendered.
    # Since we are not invoking Devise's Sign-Up page using devise's route "/users/signup", required
    # data prepared by Devise is not available.Required Devise helpers are
    # manually added to /app/helpers/application_helper.rb so that "users/registrations/new"
    # gets correctly included on Welcome Page itself.
    set_mquest_details
  end

  def index
  end

  def show

  end

  def edit

  end

  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to profile_user_path(@user), notice: 'Profile was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  #POST /users/:id/delink_as/:role/:from
  def delink
    user_id = params[:id]
    from_user_id = params[:from]
    role = params[:role]

    if (user_id.present? and from_user_id.present? and role.present?)
      if valid_role?(role)
        user = User.find_by_id(user_id)
        from_user = User.find_by_id(from_user_id)

        if (!user.nil? and !from_user.nil?)
          args = case role
                  when Mquest::MENTOR
                    { mentor_id: user_id, mentee_id: from_user_id }
                  when Mquest::MENTEE
                    { mentor_id: from_user_id, mentee_id: user_id }
                 end
          mmconnection = MentorMenteeConnection.where(args).first
          msg_args = { user_name: user.name, from_user_name: from_user.name, role: role }
          if mmconnection.nil?
             message = t('user.mentor_mentee_connection.delink.messages.not_linked', msg_args)
          else
             mmconnection.delete
             message = t('user.mentor_mentee_connection.delink.messages.success', msg_args)
          end
        else
          message = t('user.mentor_mentee_connection.delink.errors.no_user_found', { user_id: user_id, from_user_id: from_user_id })
        end
      else
        message = t('user.mentor_mentee_connection.delink.errors.invalid_role', { role: role} )
      end
    else
      message = t('user.mentor_mentee_connection.delink.errors.could_not_process_delink')
    end

    if message
      Rails.logger.error message
      redirect_to user_mquests_path(current_user), flash: { notice: message}
    end

  end

  private

  def fetch_user
    @user = User.find(params[:id])
  end

  def set_mquest_details
    @mquest_token = params[:token] if params[:token].present?

    if @mquest_token
      @mquest = Mquest.where(token: @mquest_token).first

      if @mquest.nil?
        @message = t('user.mquests.errors.mquest_token_invalid')
      else
        @message = t('user.mquests.messages.sign_in_to_accept', { receiver_name: @mquest.receiver.name, sender_name: @mquest.sender.name })
      end
    end
  end

end
