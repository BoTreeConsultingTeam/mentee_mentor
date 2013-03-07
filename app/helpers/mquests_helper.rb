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

  def most_recent_message_in_thread(message_thread)
    return nil if message_thread.nil?

    most_recent_message = nil
    messages = message_thread.messages
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
        include_message_header = true
        thread_messages_arr.each do |message|
          content_html << message_html(message, include_message_header)
          include_message_header = true
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
    div_options = {}
    div_options[:id] = "#{message.id}_message"
    div_options[:class] = 'acknowledged' if (message_sender_current_user?(message) or !message.unacknowledged?)
    content << content_tag(:div, div_options) do
                concat(message_header(message)) if include_message_header
                concat(simple_format(message.content))
                concat(mark_as_read_or_unread_link_content(message))
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

  def mark_as_read_or_unread_link_content(message)
    content = ''.html_safe
    content << content_tag(:div, class: 'messageMarkLinkContainer') do
                concat(break_tag)
                concat(mark_as_read_or_unread_link(message))
              end
    content
  end

  def mark_as_read_or_unread_link(message)
    message_unacknowledged = message.unacknowledged?
    unless message_sender_current_user?(message)
      if message_unacknowledged
        link_to(t('mquest.mark_as_read_link'), mquest_mark_as_read_path(message), remote: true, method: :put).html_safe
      else
        link_to(t('mquest.mark_as_unread_link'), mquest_mark_as_unread_path(message), remote: true, method: :put).html_safe
      end
    end
  end

  def message_sender_current_user?(message)
    message_sender_id = message.sender.id
    (message_sender_id == current_user.id)
  end

end
