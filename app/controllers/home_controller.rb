class HomeController < ApplicationController
  def index
    @ticket_number = Ticket.last.ticket_number.to_i + 1
    @ticket_number = @ticket_number.to_s
  end
end
