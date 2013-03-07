class SearchesController < ApplicationController
  before_filter :require_user

  def index
    search_term = params[:search_term]

    # Uses the "page" scope of Kaminari Paginator (https://github.com/amatsuda/kaminari)
    @users = search_users(search_term)
    @users = Kaminari.paginate_array(@users).page(params[:page]).per(10)
  end

  private

  def search_users(search_term)
    arel = User.includes(:profile).joins(:profile)

    unless search_term.blank?
      query_params = Array.new(8, "%#{search_term}%")

      # Reference:
      # http://blog.grayproductions.net/articles/working_with_multiline_strings
      users_where_clause = <<USERS_WHERE_CLAUSE.gsub(/\s+/, " ").strip
          users.first_name LIKE ? OR
          users.last_name LIKE ? OR
          users.email LIKE ?
USERS_WHERE_CLAUSE

      profile_where_clause = <<PROFILES_WHERE_CLAUSE.gsub(/\s+/, " ").strip
          profiles.first_name LIKE ? OR
          profiles.last_name LIKE ?  OR
          profiles.interests LIKE ?  OR
          profiles.hometown LIKE ?  OR
          profiles.current_location LIKE ?
PROFILES_WHERE_CLAUSE

      sql = "#{users_where_clause} OR #{profile_where_clause}"
      arel = arel.where(sql, *query_params).order("users.first_name ASC, users.last_name ASC, profiles.first_name ASC, profiles.last_name ASC")
    end
    arel
  end

end
