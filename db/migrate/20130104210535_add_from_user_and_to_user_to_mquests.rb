class AddFromUserAndToUserToMquests < ActiveRecord::Migration
  def self.up
    add_column :mquests, :from_user, :integer
    add_column :mquests, :to_user, :integer
  end

  def self.down
    remove_column :mquests, :from_user, :integer
    remove_column :mquests, :to_user, :integer
  end

end
