class DropMquestsTable < ActiveRecord::Migration
  def up
    drop_table :mquests
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
