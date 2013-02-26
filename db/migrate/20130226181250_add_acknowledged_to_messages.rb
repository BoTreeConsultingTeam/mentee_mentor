class AddAcknowledgedToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :acknowledged, :boolean, default: false
  end
end
