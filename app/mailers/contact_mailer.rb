class ContactMailer < ApplicationMailer
  def new_contact( ticket_number, name, email, facility, body )
    @ticket_number = ticket_number
    @name = name
    @email = email
    @body = body
    @facility = facility

    mail to: "ekvitko@qrpgroup.com",
         subject: 'New Ticket'
  end
end
