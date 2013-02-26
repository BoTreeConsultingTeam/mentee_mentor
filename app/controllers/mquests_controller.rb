class MquestsController < ApplicationController

  respond_to :js, only: [:show, :send]

  before_filter :require_user

  # GET /users/:user_id/mquests
  def index
    @other_users = current_user.other_users_except_me
    @mquest_active = true
  end

  # GET /users/:user_id/mquests/:id(.:format)
  def show
    sender_id = params[:user_id]
    receiver_id = params[:id]

    @error = false
    if(!sender_id.present? and !receiver_id.present?)
      Rails.logger.debug "Could not show mquest.Required 'user_id' and/or 'id' params found missing in request url."
      @error = true
      @error_message = t('mquest.error.could_not_show_mquest')
    end

    unless @error
      @sender = User.find_by_id(sender_id)
      @receiver = User.find_by_id(receiver_id)

      if(@sender.nil? or @receiver.nil?)
        @error = true
        @error_message = t('mquest.error.inexistent_user', user_id: sender_id)
      end

      @messages_exchanged = @sender.messages_exchanged_with_user(@receiver.id) unless @error
    end
  end

  # POST /users/:user_id/mquests(.:format)
  def create
    @message = Message.new(params[:message])

    @message.save  if @message.valid?

    respond_with do |format|
       format.js {
         @receiver = @message.receiver
         @sender = @message.sender
         @messages_exchanged = @sender.messages_exchanged_with_user(@receiver.id)
         render file: "mquests/show"
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
