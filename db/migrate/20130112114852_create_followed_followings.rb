class CreateFollowedFollowings < ActiveRecord::Migration
  def change
    create_table :followed_followings do |t|
      t.integer :followed_id
      t.integer :following_id

      t.timestamps
    end
  end
end
