class RenameTypeToResourceTypeInResources < ActiveRecord::Migration
  def up
  	rename_column :resources, :type, :resource_type
  end

  def down
  	rename_column :resources, :resource_type, :type
  end
end
