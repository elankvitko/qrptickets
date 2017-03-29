class TicketController < ApplicationController
  before_action :authenticate_user!

  def index
    @unread = mailbox.inbox(:unread => true).count

    if current_user.admin
      @tickets = Ticket.order( :id )
    else
      @tickets = current_user.tickets.order( :id )
    end
  end

  def new
    @unread = mailbox.inbox(:unread => true).count
    @ticket = Ticket.new
    @ticket_number = Ticket.all.length + 1
  end

  def create
    if request.xhr?
      ticket = Ticket.new( ticket_params )
      if ticket.save
        redirect_to ticket_index_path
      end
    end
  end

  def edit
    if request.xhr?
      if current_user.full_name.downcase == 'elan kvitko'
        @ticket = Ticket.find_by( ticket_number: params[ 'id' ] )
        @ticket.update_attributes( viewed: true )
      end
    end
  end

    private

    def ticket_params
      params.require( :ticket ).permit( :user_id, :location, :ticket_number, :body )
    end
end
