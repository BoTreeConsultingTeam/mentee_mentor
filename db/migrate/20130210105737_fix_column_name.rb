class FixColumnName < ActiveRecord::Migration
  def up
  	rename_column :resources, :type, :resource_type
  end

  def down
  end
end
