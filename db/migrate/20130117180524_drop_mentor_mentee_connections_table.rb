class DropMentorMenteeConnectionsTable < ActiveRecord::Migration
  def up
    drop_table :mentor_mentee_connections
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
