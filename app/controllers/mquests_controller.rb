class MquestsController < ApplicationController

  respond_to :js, only: [:create]

  before_filter :require_user

  # GET /users/:user_id/mquests
  def index
    @messages_received = current_user.messages_received
    @mquest_active = true
  end

  # POST /users/:user_id/mquests(.:format)
  def create
    @message = Message.new(params[:message])

    if @message.valid?
      @message.save
      @message_sent = true
    end

    respond_with do |format|
       format.js {
         @receiver = @message.receiver
         @sender = @message.sender
         render file: "mquests/show_message_status"
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
