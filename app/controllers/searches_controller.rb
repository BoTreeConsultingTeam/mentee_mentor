class SearchesController < ApplicationController
  before_filter :require_user

  def index
    search_term = params[:search_term]

    # Uses the "page" scope of Kaminari Paginator (https://github.com/amatsuda/kaminari)
    @users = search_users(search_term)

    # This is needed because when a user doesn't have a profile, which can happen
    # when a user signs up(not through LinkedIn in which case User's first name
    # and last name gets set under USERS table) and logs out without creating a
    # profile, the user's email doesn't show up in order in search results.
    # Thus programmatically sorting the results here to display the search
    # results in correct order.
    @users = sort_users(@users)

    @users = Kaminari.paginate_array(@users).page(params[:page]).per(10)
  end

  private

  def search_users(search_term)
    arel = User.includes(:profile).joins('LEFT OUTER JOIN profiles ON profiles.user_id = users.id')
    # Reference: http://stackoverflow.com/questions/4252349/rail-3-where-condition-using-not-null
    arel = arel.where(User.arel_table[:id].not_eq(current_user.id))

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
      arel = arel.where(sql, *query_params)
    end

    arel = arel.order("profiles.first_name ASC, users.first_name ASC")

    arel
  end

  def sort_users(users_arr)
    return users_arr if users_arr.nil? or users_arr.empty?

    hash = {}
    users_arr.each do |user|
      profile = user.profile
      profile_first_name = profile.first_name unless profile.nil?
      user_first_name = user.first_name
      user_email = user.email

      key = nil
      if profile_first_name
        key = profile_first_name
      elsif user_first_name
        key = user_first_name
      else
        key = user_email.split("@").first
      end

      # Capitalizing it since capital alphabet when compared with small alphabet
      # returns -1.Thus to make the keys comparison consistent capitalizing each
      # key.
      key = key.capitalize.to_sym
      if hash.has_key?(key)
        hash[key] << user
      else
        hash[key] = [ user ]
      end
    end

    sorted_keys = hash.keys.sort

    sorted_users = sorted_keys.inject([]) do |collector, key|
      collector << hash[key]
      collector.flatten!
    end

    sorted_users
  end

end
