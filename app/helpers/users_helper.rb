module UsersHelper
  def current_user_profile_picture_path(style = :thumb)
    user_profile_picture_path(current_user, style)
  end

  def user_profile_picture_path(user, style = :thumb)
    return "" if user.nil?

    if user.profile.nil?
      picture_path = 'no-user-picture.png'
    else
      picture_path = user.profile.photo.url(style)
    end
    picture_path
  end

  def formatted_timeline_status_datetime(datetime)
    return '' unless datetime.present?
    time_ago_in_words(datetime, true)
  end
end
