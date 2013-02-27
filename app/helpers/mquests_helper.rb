module MquestsHelper
  def formatted_message_datetime(datetime)
    return '' unless datetime.present?
    time_ago_in_words(datetime, true)
  end

  def formatted_reply_message_datetime(datetime)
    return '' unless datetime.present?
    datetime.strftime(t('mquest.format.datetime'))
  end

  def reply_message_default_content(received_message_obj)
    message_sender = received_message_obj.sender
    message_datetime = received_message_obj.datetime
    message_content = received_message_obj.content
    reply_message_text = "------------------------------------------------------\n"
    reply_message_text << "On #{formatted_reply_message_datetime(message_datetime)}, #{message_sender.name} wrote:"
    reply_message_text << "\n"
    reply_message_text << message_content
    reply_message_text
  end
end
