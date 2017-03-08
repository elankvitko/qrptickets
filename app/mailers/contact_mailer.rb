class ContactMailer < ApplicationMailer
  def new_contact( ticket_number, name, email, body )
    @ticket_number = ticket_number
    @name = name
    @email = email
    @body = body

    mail to: "ekvitko@qrpgroup.com",
         subject: 'New Ticket'
  end
end
