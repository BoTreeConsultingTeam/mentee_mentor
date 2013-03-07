class ChangeDateToDateTimeInMessages < ActiveRecord::Migration
  def up
    # This is done for running migrations successfully for changing columns
    # data-type on Heroku:
    # Reference: http://stackoverflow.com/questions/3075920/how-do-i-change-column-type-in-heroku
    rename_column :messages, :date, :date_entered_date
    add_column :messages, :datetime, :datetime, null:false

    Message.reset_column_information
    Message.find_each { |message| message.update_attribute(:datetime, message.date_entered_date) }
    remove_column :messages, :date_entered_date

  end

  def down
    change_table :messages do |t|
      t.change :date, :date
    end
  end
end
