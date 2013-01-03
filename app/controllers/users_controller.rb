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

  private

  def fetch_user
    @user = User.find(params[:id])
  end

  # def build_profile
    # @user.build_profile if @user.profile.nil?
  # end

end
