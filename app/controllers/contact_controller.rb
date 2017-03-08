class ContactController < ApplicationController
  def create
    if request.xhr?
      @ticket = Ticket.create( ticket_number: params[ 'ticket_number' ], name: params[ 'name' ], email: params[ 'email' ], facility: params[ 'facility' ], body: params[ 'body' ] )

      ContactMailer.new_contact( params[ 'ticket_number' ], params[ 'name' ], params[ 'email' ], params[ 'facility' ], params[ 'body' ] ).deliver_now
      render partial:'success', layout: false
    end
  end
end
