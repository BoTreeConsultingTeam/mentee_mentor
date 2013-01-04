class UserMailer < ActionMailer::Base
  default from: Settings.mail.from

  def mquest_email(mquest)
    @as_role = mquest.as_role

    requestor_user_id, requested_user_id = case as_role
                                           when Mquest::MENTEE
                                             [mquest.mentee_id, mquest.mentor_id]
                                           when Mquest::MENTOR
                                             [mquest.mentor_id, mquest.mentee_id]
                                           end

    begin
      @requestor = User.find(requestor_user_id)
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error "Mquest initiater [id: #{requestor_user_id}] user could not be found in system while sending Mquest email."
      @requestor = nil
    end

    begin
      @requested = User.find(requested_user_id)
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error "Mquest received [id: #{requested_user_id}] user could not be found in system while sending Mquest email."
      @requested = nil
    end

    unless (@requestor.nil? or @requested.nil?)
      mail(to: @requested.email, subject: t('user.mails.mquest.subject', { role: as_role }))
    end

  end
end
