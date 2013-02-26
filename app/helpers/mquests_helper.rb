module MquestsHelper
  def formatted_message_datetime(datetime)
    return datetime unless datetime.present?
    time_ago_in_words(datetime, true)
  end
end
