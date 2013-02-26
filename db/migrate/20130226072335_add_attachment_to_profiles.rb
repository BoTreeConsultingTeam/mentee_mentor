class AddAttachmentToProfiles < ActiveRecord::Migration
  def change
    add_attachment :profiles, :photo
  end
end
