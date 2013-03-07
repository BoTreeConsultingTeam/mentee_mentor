class ChangeBirthdayTypeToDateInProfiles < ActiveRecord::Migration
  def up
    rename_column :profiles, :birthday, :birthday_entered_string
    add_column :profiles, :birthday, :date

    Profile.reset_column_information
    Profile.find_each { |profile| profile.update_attribute(:birthday, profile.birthday_entered_string) }
    remove_column :profiles, :birthday_entered_string
  end

  def down
    change_table :profiles do |t|
      t.change :birthday, :string
    end
  end
end
