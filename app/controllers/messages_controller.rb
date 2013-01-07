class MessagesController < ApplicationController
  before_filter :require_user

  def create
     @message = Message.new(params[:message])

     @message_errors = []
     @message_errors += collect_validation_errors(@message)

     if @message.message_thread.nil?
        @message_thread = @message.build_message_thread(params[:message_thread])
        @message_thread.starter = @message.sender
        @message_errors += collect_validation_errors(@message_thread)
     end

     if @message_errors.empty?
       @message.save
       # /app/views/users/_list_dialogues_name.html.haml uses @user instance
       # variable which originally points to current logged in user.However
       # when rendering this file through this action's JS response, @user is
       # not set.Thus explicitly setting it here.
       @user = @message.sender
     else
       Rails.logger.debug "Message errors found: #{@message_errors}"
     end

     respond_to do |format|
       format.js {
         render file: "messages/message_status"
       }
     end
  end

  private

  def collect_validation_errors(object)
     errors = []
     unless object.valid?
        object.errors.full_messages.each do |msg|
          errors << msg
        end
     end
     errors
  end
end
