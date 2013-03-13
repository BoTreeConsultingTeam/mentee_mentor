class UsersController < ApplicationController

  before_filter :require_user, except: [:welcome]

  before_filter :fetch_user, only: [:show, :change_password, :edit, :upload_picture, :update, :update_status, :mboard]

  def welcome
    # On the welcome page itself Sign Up page is rendered.
    # Since we are not invoking Devise's Sign-Up page using devise's route "/users/signup", required
    # data prepared by Devise is not available.Required Devise helpers are
    # manually added to /app/helpers/application_helper.rb so that "users/registrations/new"
    # gets correctly included on Welcome Page itself.
    if user_signed_in?
      redirect_to user_home_path and return
    end

    @welcome_page_active = true # Used in /app/views/layouts/_logo.html.haml
    render layout: "welcome_page_layout"
  end

  def index
    if (!current_user.encrypted_password.present? or current_user.profile.nil?)
      redirect_to profile_edit_user_path(current_user) and return
    end

    set_statuses_for_timeline_view
    @dashboard_active = true
  end

  def show
    render file: "users/profile/show"
  end

  #PUT /users/:id/change_password(.:format
  def change_password
    skip_password_check = false
    # Validate User details
    if (@user.encrypted_password.present? and params[:user][:password].blank?)
      params[:user].delete(:password)
      params.delete(:confirm_password)
      skip_password_check = true
    end

    @user.password = params[:user][:password]
    valid_user = @user.valid?

    valid_user = password_match? if (valid_user and !skip_password_check)

    unless valid_user
      @user.encrypted_password = nil
      render file: "users/profile/edit" and return
    end

    # Save the updated details.
    @user.save

    # IMPORTANT NOTE:
    # Without invoking Devise's sign_in(:user, @user) after updating user
    # the Devise helper current_user returns nil.
    # I suspect it can be because of following reason:
    # When creating a user in database who logs in through Facebook, we create
    # a user without any password and call Devise's sign_in(:user, user)
    # But inspecting "session" after that we find this:
    # "warden.user.user.key"=>["User", [37], ""]}

    # On the other hand after a user sign-up with password, inspecting
    # the session we find this:
    # "warden.user.user.key"=>["User", [37], "$2a$10$oduLbvK.NUx1Jz4Vr7.gde"]}
    # The encrypted portion is part of password which is missing when we create
    # a user and make him sign-in.

    # Commented by: Jignesh Gohel, Dec 29, 2012
    # References: https://github.com/plataformatec/devise/issues/1528
    sign_in(@user, bypass: true)

    redirect_to profile_edit_user_path(@user)
  end

  def edit
    render file: "users/profile/edit"
  end

  #POST /users/:id/upload_picture
  def upload_picture
    profile = @user.profile

    if profile.nil?
      profile = profile.create(photo: params[:photo])
    else
      profile.update_attribute(:photo, params[:photo])
    end

    render json: profile.photo.url(:thumb)
  end

  def update
    discard_blank_experiences
    discard_blank_educations

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to profile_user_path(@user), notice: 'Profile was successfully updated.' }
      else
        format.html { render file: "users/profile/edit" }
      end
    end
  end

  # POST  /users/:id/update_status(.:format)
  def update_status
    if @user.nil?
      @error_message = t('dashboard.update_status.user_id_missing')
    else
      @user_current_status = @user.statuses.create(params[:status])
      @status_update_message = t('dashboard.update_status.messages.success')
    end

    respond_to do |format|
      format.js {
         set_statuses_for_timeline_view
         render file: "users/dashboard/update_status"
      }
    end
  end

  #GET /users/:id/refresh_timeline(.:format)
  def refresh_timeline
    set_statuses_for_timeline_view
    respond_to do |format|
      format.js {
         render file: "users/dashboard/update_timeline"
      }
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

    redirect_to :back, flash: { notice: message}
  end

  #DELETE /users/:id/unfollow/:following_user_id(.:format)
  def unfollow
    user_id = params[:id]
    following_user_id = params[:following_user_id]

    if (user_id.present? and following_user_id.present?)
       user = User.find_by_id(user_id)
       following_user = User.find_by_id(following_user_id)

       if (!user.nil? and !following_user.nil?)
         if !user.follows.exists?(following_user)
           message = t('user.unfollow.messages.already_not_following', {following_user_name: following_user.name})
         else
           followed_following_obj = user.unfollow(following_user_id)
           if followed_following_obj.nil?
             message = t('user.unfollow.messages.failure', { following_user_name: following_user.name })
           else
             message = t('user.unfollow.messages.success', { following_user_name: following_user.name })
           end
         end
       else
        message = t('user.unfollow.errors.no_user_found', { user_id: user_id, following_user_id: following_user_id })
       end
    else
      message = t('user.unfollow.errors.could_not_process_unfollow')
    end

    redirect_to :back, flash: { notice: message }
  end

  #GET /users/:id/mboard
  def mboard
    @users = User.where("id != ?", current_user.id)
    render file: "users/mboard/index"
  end

  private

  def fetch_user
    @user = User.find(params[:id])
  end

  def password_match?
    password = @user.password
    password_confirmation = params[:confirm_password]
    @user.errors.add(:password_confirmation, "can't be blank") if password_confirmation.blank?
    @user.errors.add(:password_confirmation, "does not match password") if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

  def set_statuses_for_timeline_view
    following_users = current_user.is_following
    timeline_users = following_users + [ current_user ]

    timeline_users_id_arr = timeline_users.collect { |user| user.id }
    @updated_statuses = Status.where(user_id: timeline_users_id_arr ).order('statuses.updated_at DESC')
  end

  def discard_blank_experiences
    received_experiences = params[:user][:profile_attributes][:experiences_attributes]

    if received_experiences.present?
      experiences_with_values = []
      received_experiences.each do |experience_hash|
        id = experience_hash[:id]
        _destroy = experience_hash[:_destroy]

        # if id and _destroy are present then this means an existing experience
        # should be deleted.And thus there is no sense in checking if any
        # experience details is present because there will be none.
        if (id.present? and _destroy.present?)
          experiences_with_values << experience_hash
          next
        end

        company = experience_hash[:company]
        company = company.strip if company.present?

        description = experience_hash[:description]
        description = description.strip if description.present?

        from_date = experience_hash[:from_date]
        from_date = from_date.strip if from_date.present?

        to_date = experience_hash[:to_date]
        to_date = to_date.strip if to_date.present?

        if (company.present? or description.present? or from_date.present? or to_date.present?)
          experiences_with_values << experience_hash
        end
      end

      if experiences_with_values.empty?
        params[:user][:profile_attributes].delete(:experiences_attributes)
      else
        params[:user][:profile_attributes][:experiences_attributes] = experiences_with_values
      end

    end
  end

  def discard_blank_educations
    received_educations = params[:user][:profile_attributes][:educations_attributes]

    if received_educations.present?
      educations_with_values = []
      received_educations.each do |education_hash|
        id = education_hash[:id]
        _destroy = education_hash[:_destroy]

        # if id and _destroy are present then this means an existing education
        # should be deleted.And thus there is no sense in checking if any
        # education details is present because there will be none.
        if (id.present? and _destroy.present?)
          educations_with_values << education_hash
          next
        end

        school = education_hash[:school]
        school = school.strip if school.present?

        study_field = education_hash[:study_field]
        study_field = study_field.strip if study_field.present?

        from_date = education_hash[:from_date]
        from_date = from_date.strip if from_date.present?

        to_date = education_hash[:to_date]
        to_date = to_date.strip if to_date.present?

        if (school.present? or study_field.present? or from_date.present? or to_date.present?)
          educations_with_values << education_hash
        end
      end

      if educations_with_values.empty?
        params[:user][:profile_attributes].delete(:educations_attributes)
      else
        params[:user][:profile_attributes][:educations_attributes] = educations_with_values
      end

    end
  end

end
