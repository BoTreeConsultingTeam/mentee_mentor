class Mquest < ActiveRecord::Base

  MENTEE = "mentee"
  MENTOR = "mentor"

  belongs_to :receiver, class_name: "User", foreign_key: 'to_user'
  belongs_to :sender, class_name: "User", foreign_key: 'from_user'

  attr_accessible :from_user, :to_user, :token, :as_role

  before_create :remove_stale_mquests, :set_token

  # Remove stale mquests for a single mentor/mentee
  # pair before creating a new mquest.
  def remove_stale_mquests
    args = {}
    args[:from_user] = self.from_user unless self.from_user.nil?
    args[:to_user] = self.to_user unless self.to_user.nil?
    args[:as_role] = self.as_role unless self.as_role.nil?
    stale_mquests = Mquest.where(args)
    stale_mquests.delete_all unless stale_mquests.empty?
  end

  def set_token
    # References:
    # [1] http://stackoverflow.com/questions/6127995/generating-unique-32-character-strings-in-rails-3
    # [2] https://github.com/scambra/devise_invitable/issues/159
    self.token = loop do
                   token = SecureRandom.hex 16
                   break token unless Mquest.find_by_token(token)
                 end
  end

  def send_notification
    success = true
    begin
      UserMailer.mquest_email(self).deliver
    rescue Exception => e
      Rails.logger.debug "Exception occured while trying to send mquest [token: #{token}] email.Details are: #{e.to_s}"
      success = false
    end
    success
  end
end
