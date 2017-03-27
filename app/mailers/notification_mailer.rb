class NotificationMailer < ApplicationMailer
  def new_notification( name, email )
    @name = name

    mail to: email,
         subject: "Ticket Notification"
  end
end
