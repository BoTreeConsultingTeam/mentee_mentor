class AddNotNullConstraintToMquestFields < ActiveRecord::Migration
  def self.up
    change_column :mquests, :token, :string, null: false
    change_column :mquests, :as_role, :string, null: false
    change_column :mquests, :from_user, :integer, null: false
    change_column :mquests, :to_user, :integer, null: false
  end

  def self.down
    change_column :mquests, :token, :string, null: true
    change_column :mquests, :as_role, :string, null: true
    change_column :mquests, :from_user, :integer, null: true
    change_column :mquests, :to_user, :integer, null: true
  end

end
