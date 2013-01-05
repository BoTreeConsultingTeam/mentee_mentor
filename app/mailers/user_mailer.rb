class UserMailer < ActionMailer::Base
  default from: Settings.mail.from

  def mquest_email(mquest)
    @as_role = mquest.as_role
    @from = mquest.sender
    @to = mquest.receiver
    @mquest_token = mquest.token

    mail(to: @to.email, subject: t('user.mails.mquest.subject', { role: @as_role }))
  end
end
