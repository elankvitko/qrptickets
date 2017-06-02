class NotifyLidiyaMailer < ApplicationMailer
  def new_notification
    mail to: 'lidiya@qrpgroup.com',
         subject: "Project Notification"
  end
end
