# Reference: http://blog.crowdint.com/2011/03/02/how-to-make-your-models-look-lean.html
module GeneralScopes
    extend ActiveSupport::Concern

    included do
      # Reference: http://stackoverflow.com/questions/5024337/how-to-specify-a-rails-3-scope-limit-with-an-offset
      scope :oldest_first, order: "created_at ASC"
      scope :newest_first, order: "created_at DESC"
      scope :reverse_order_by_date, :order => "date DESC"
      scope :recent, lambda { |count| reverse_order_by_date.limit(count) }
      scope :order_by_updated_at, order: "updated_at ASC"
      scope :modified_after,  lambda { |datetime| where(['updated_at > ?', datetime]) }
      scope :modified_before,  lambda { |datetime| where(['updated_at < ?', datetime]) }
      scope :modified_between,  lambda { |start_datetime, end_datetime| where(updated_at: start_datetime..end_datetime) }
    end
end
