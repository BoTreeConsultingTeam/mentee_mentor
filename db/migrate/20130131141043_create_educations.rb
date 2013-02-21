class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.string :school
      t.date :from_date
      t.date :to_date
      t.string :degree
      t.string :study_field
      t.integer :profile_id

      t.timestamps
    end
  end
end
