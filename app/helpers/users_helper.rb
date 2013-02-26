module UsersHelper
  def current_user_profile_picture_path(style = :thumb)
    if current_user.profile.nil?
      picture_path = 'no-user-picture.png'
    else
      picture_path = current_user.profile.photo.url(style)
    end
  end
end
