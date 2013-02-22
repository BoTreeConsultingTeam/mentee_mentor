class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :content
      t.string :type
      t.integer :user_id

      t.timestamps
    end
  end
end
