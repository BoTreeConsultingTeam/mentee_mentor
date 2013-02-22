class UsersController < ApplicationController

  before_filter :require_user, except: [:welcome]

  before_filter :fetch_user, only: [:show, :edit, :update, :mboard, :all_dialogues]

  def welcome
    # On the welcome page itself Sign Up page is rendered.
    # Since we are not invoking Devise's Sign-Up page using devise's route "/users/signup", required
    # data prepared by Devise is not available.Required Devise helpers are
    # manually added to /app/helpers/application_helper.rb so that "users/registrations/new"
    # gets correctly included on Welcome Page itself.
    @welcome_page_active = true # Used in /app/views/layouts/_logo.html.haml
    render layout: "welcome_page_layout"
  end

  def index
    @dashboard_active = true
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

  #POST /users/:id/follow/:follow_user_id/
  def follow
    user_id = params[:id]
    follow_user_id = params[:follow_user_id]

    if (user_id.present? and follow_user_id.present?)
       user = User.find_by_id(user_id)
       follow_user = User.find_by_id(follow_user_id)

       if (!user.nil? and !follow_user.nil?)
         if user.follows.exists?(follow_user)
           message = t('user.follow.messages.already_following', {follow_user_name: follow_user.name})
         else
           followed_following_obj = FollowedFollowing.create(following_id: user_id, followed_id: follow_user_id)
           if followed_following_obj.nil?
             message = t('user.follow.messages.failure', { follow_user_name: follow_user.name })
           else
             message = t('user.follow.messages.success', { follow_user_name: follow_user.name })
           end
         end
       else
        message = t('user.follow.errors.no_user_found', { user_id: user_id, follow_user_id: follow_user_id })
       end
    else
      message = t('user.follow.errors.could_not_process_follow')
    end

    Rails.logger.debug message
    redirect_to user_home_path, flash: { notice: message}

  end

  #GET /users/:id/mboard
  def mboard
    @users = User.where("id != ?", current_user.id)
    render file: "users/mboard/index"
  end

  #GET /users/:id/all_dialogues/:with
  def all_dialogues
    with_user_id = params[:with]

    if with_user_id.present?
      @sender_id = @user.id
      @receiver_id = with_user_id
      @message_threads_exchanged = @user.message_threads_exchanged_with(with_user_id)
      render file: "users/dialogues/all_dialogues"
      return
    else
      message = t('user.mboard.errors.could_not_fetch_dialogues')
      Rails.logger.error message
    end
    redirect_to mboard_user_path(@user), flash: { error: message }
  end

  private

  def fetch_user
    @user = User.find(params[:id])
  end
end
