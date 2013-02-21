class RemoveUserIdFromResources < ActiveRecord::Migration
  def up
    remove_column :resources, :user_id
  end

  def down
    add_column :resources, :user_id, :integer
  end
end
