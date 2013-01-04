class RemoveMentorIdAndMenteeIdFromMquests < ActiveRecord::Migration
  def up
    remove_column :mquests, :mentor_id
    remove_column :mquests, :mentee_id
  end

  def down
    add_column :mquests, :mentee_id, :integer
    add_column :mquests, :mentor_id, :integer
  end
end
