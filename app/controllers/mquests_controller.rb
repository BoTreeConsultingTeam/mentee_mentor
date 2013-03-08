class MquestsController < ApplicationController

  respond_to :js, only: [:create]

  before_filter :require_user

  before_filter :find_message, only: [:mark_as_read, :mark_as_unread]

  # GET /users/:user_id/mquests
  def index
    set_current_user_message_threads
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
         set_current_user_message_threads
         render file: "mquests/show_message_status"
       }
    end
  end

  # PUT /mquests/:id/mark_as_read(.:format)
  def mark_as_read
    unless @message.nil?
      @message.acknowledge
      @message_mark_as_read = true
    end

    respond_with do |format|
       format.js {
         render file: "mquests/update_message_acknowledged_status"
       }
    end
  end

  # PUT /mquests/:id/mark_as_unread(.:format)
  def mark_as_unread
    unless @message.nil?
      @message.unacknowledge
      @message_mark_as_unread = true
    end

    respond_with do |format|
       format.js {
         render file: "mquests/update_message_acknowledged_status"
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

  def find_message
    @message = Message.find_by_id(params[:id])
  end

  def set_current_user_message_threads
    @current_user_message_threads = current_user.message_threads
  end
end
