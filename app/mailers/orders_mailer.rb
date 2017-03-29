class OrdersMailer < ApplicationMailer
  def new_order
    mail to: "enovikova@qrpgroup.com",
         subject: "New Order Request"
  end
end
