module SearchesHelper
  def user_description(user)
    user_description = ''.html_safe
    profile = user.profile
    unless profile.nil?
      recent_experience = profile.experiences.first
      user_description << content_tag(:p, recent_experience.formatted_description) unless recent_experience.nil?

      current_location = profile.current_location
      user_description << content_tag(:p, current_location) if current_location.present?
    end
    user_description
  end
end
