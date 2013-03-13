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
    sort_users(@users)

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
    users_arr.sort! do |a, b|
      b_profile = b.profile
      a_profile = a.profile

      b_first_name = b.first_name
      a_first_name = a.first_name

      b_email = b.email
      a_email = a.email

      if (b_profile.present? or a_profile.present?)
        # Both user's profile available
        if (b_profile.present? and a_profile.present?)
          a_profile.first_name <=> b_profile.first_name
        # b user's profile available and a user's profile unavailable
        elsif (b_profile.present? and !a_profile.present?)
          if a_first_name.present?
            a_first_name <=> b_profile.first_name
          else
            a_email <=> b_profile.first_name
          end
        # b user's profile unavailable and a user's profile available
        elsif (!b_profile.present? and a_profile.present?)
          if b_first_name.present?
            a_profile.first_name <=> b_first_name
          else
            a_profile.first_name <=> b_email
          end
        end
      elsif (b_first_name.present? or a_first_name.present?)
        if (b_first_name.present? and a_first_name.present?)
          a_first_name <=> b_first_name
        elsif (b_first_name.present? and !a_first_name.present?)
          a_email <=> b_first_name
        elsif (!b_first_name.present? and a_first_name.present?)
          a_first_name <=> b_email
        end
      else
        a_email <=> b_email
      end
    end
  end


end
