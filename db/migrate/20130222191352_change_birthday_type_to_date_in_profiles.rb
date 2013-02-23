class ChangeBirthdayTypeToDateInProfiles < ActiveRecord::Migration
  def up
    change_table :profiles do |t|
      t.change :birthday, :date
    end
  end

  def down
    change_table :profiles do |t|
      t.change :birthday, :string
    end
  end
end
