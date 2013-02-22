class AddBiographyGenderInterestsRecentActivitiesToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :biography, :string
    add_column :profiles, :gender, :string
    add_column :profiles, :interests, :string
    add_column :profiles, :recent_activities, :string
  end
end
