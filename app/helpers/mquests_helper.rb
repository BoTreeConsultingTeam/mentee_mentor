module MquestsHelper
  def formatted_message_datetime(datetime)
    return '' unless datetime.present?
    time_ago_in_words(datetime, true)
  end

  def received_message_header_formatted_datetime(datetime)
    return '' unless datetime.present?
    datetime.strftime(t('mquest.format.datetime'))
  end

  def most_recent_message_received_in_thread(message_receiver, message_thread)
    return nil if message_thread.nil? or message_receiver.nil?

    most_recent_message = nil
    messages = message_receiver.messages_received_in_thread(message_thread)
    unless messages.empty?
      most_recent_message = messages.first
    end
    most_recent_message
  end

  def formatted_message_thread(message_thread)
    content_html = ''.html_safe

    unless message_thread.nil?
      thread_messages_arr = message_thread.messages

      unless thread_messages_arr.empty?
        include_message_header = false
        most_recent_message = thread_messages_arr.first
        # If current user is not sender of the most recent message in
        # thread_messages_arr then only display it which will mean it was
        # the message received by current user from other user in the message
        # thread
        if !is_message_sender_current_user?(most_recent_message)
          content_html << message_html(most_recent_message, include_message_header)
          include_message_header = true
        end

        # Remove the most recent message from the thread_messages_arr in either
        # case: most_recent_message is added to display or not
        thread_messages_arr.shift

        unless thread_messages_arr.empty?
          thread_messages_arr.each do |message|
            content_html << message_html(message, include_message_header)
            include_message_header = true
          end
        end

      end

    end

    content_html
  end

  def break_tag
    "<br/>".html_safe
  end

  def message_html(message, include_message_header=true)
    # References:
    # 1) http://stackoverflow.com/questions/287713/how-do-i-remove-carriage-returns-with-ruby
    # 2) http://stackoverflow.com/questions/611609/in-rails-is-there-a-rails-method-to-convert-newlines-to-br
    content = ''.html_safe
    content << content_tag(:div) do
                concat(message_header(message)) if include_message_header
                concat(simple_format(message.content))
              end
    content << break_tag
    content
  end

  def message_header(message)
    content = ''.html_safe
    content << content_tag(:p, "-" * 100)
    sender_name = is_message_sender_current_user?(message) ? "You" : message.sender.name
    content << t('mquest.format.received_message_header', message_datetime: received_message_header_formatted_datetime(message.datetime), sender_name: sender_name)
    content
  end

  def is_message_sender_current_user?(message)
    return false if message.nil?
    message.sender.id == current_user.id
  end

  def is_message_thread_starter_current_user?(message_thread)
    return false if message_thread.nil?
    message_thread.starter.id == current_user.id
  end

end
