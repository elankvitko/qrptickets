class TicketController < ApplicationController
  before_action :authenticate_user!
  include TicketHelper

  def index
    # SDK.search('/', Ticket.last.filename)[0]["path"]
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
    ticket = Ticket.new( ticket_params )

    if params[ :ticket ][ :uploaded ]
      file = params[ :ticket ][ :uploaded ]
      ticket.update_attributes( filename: file.original_filename )
      dropbox.upload file.original_filename, file.tempfile
    end

    if ticket.save
      redirect_to ticket_index_path
    end
  end

  def edit
    if request.xhr?
      if current_user.full_name.downcase == 'elan kvitko'
        @ticket = Ticket.find_by( ticket_number: params[ 'id' ] )
        @ticket.update_attributes( viewed: true )
      end
    else
      @ticket = Ticket.find( params[ 'id' ] )
      @ticket.update_attributes( status: 'Complete' )
      redirect_to ticket_index_path
    end
  end

  def dl
    if request.xhr?
      ticket = Ticket.find( params[ "ticket" ] )
      path = SDK.search( '/', ticket.filename )[ 0 ][ "path" ]
      @url = SDK.media( path )[ "url" ]
      @ticket_number = params[ "ticket" ]
      render partial: 'js_response', layout: false, locals: { url: @url, ticket_number: @ticket_number }
    end
  end

    private

    def ticket_params
      params.require( :ticket ).permit( :user_id, :location, :ticket_number, :body )
    end
end
