class CreateMquests < ActiveRecord::Migration
  def change
    create_table :mquests do |t|
      t.integer :mentor_id
      t.integer :mentee_id
      t.string :token
      t.string :as_role

      t.timestamps
    end

    add_index(:mquests, :token, unique: true)
  end
end
