class OrdersMailer < ApplicationMailer
  def new_order
    mail to: "lidiya@qrpgroup.com",
         subject: "New Order Request"
  end
end
