class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.string :birthday
      t.string :hometown
      t.string :current_location
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
