class CreateMentorMenteeConnections < ActiveRecord::Migration
  def change
    create_table :mentor_mentee_connections do |t|
      t.integer :mentor_id, null: false
      t.integer :mentee_id, null: false

      t.timestamps
    end
  end
end
