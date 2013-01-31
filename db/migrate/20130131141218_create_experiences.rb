class CreateExperiences < ActiveRecord::Migration
  def change
    create_table :experiences do |t|
      t.string :company
      t.date :from_date
      t.date :to_date
      t.string :title
      t.string :location
      t.string :description
      t.integer :profile_id

      t.timestamps
    end
  end
end
