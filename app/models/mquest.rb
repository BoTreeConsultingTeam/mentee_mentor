class Mquest < ActiveRecord::Base

  MENTEE = "mentee"
  MENTOR = "mentor"

  attr_accessible :mentee_id, :mentor_id, :token, :as_role

  before_create :remove_stale_requests, :set_token
  after_create :send_notification

  # Remove stale mquests for a single mentor/mentee
  # pair before creating a new mquest.
  def remove_stale_mquests
    args = {}
    args[:mentee_id] = self.mentee_id unless self.mentee_id.nil?
    args[:mentor_id] = self.mentor_id unless self.mentor_id.nil?
    args[:as_role] = self.as_role unless self.as_role.present?
    stale_mquests = where(args)
    stale_mquests.delete_all unless stale_mquests.empty?
  end

  def set_token
    # Reference: http://stackoverflow.com/questions/6127995/generating-unique-32-character-strings-in-rails-3
    self.token = loop do
      token = ActiveSupport::SecureRandom.hex 16
      break token unless find(:first, token: token)
    end
  end

  def send_notification
    UserMailer.mrequest_email(mrequest).deliver
  end

end
