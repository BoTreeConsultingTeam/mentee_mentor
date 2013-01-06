class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :content, null:false
      t.date :date, null:false
      t.integer :sender_id, null:false
      t.integer :receiver_id, null:false
      t.integer :message_thread_id

      t.timestamps
    end
  end
end
