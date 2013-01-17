class UserMailer < ActionMailer::Base
  default from: Settings.mail.from

end
