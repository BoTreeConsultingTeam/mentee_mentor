class CreateMessageThreads < ActiveRecord::Migration
  def change
    create_table :message_threads do |t|
      t.string :title
      t.integer :starter_id, null: false

      t.timestamps
    end
  end
end
