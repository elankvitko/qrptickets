class ContactMailer < ApplicationMailer
  def new_contact( name, email, body )
    @name = name
    @email = email
    @body = body

    mail to: "ekvitko@qrpgroup.com",
         subject: 'New Ticket'
  end
end
