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

    files = params[:ticket].select { |obj, l| obj.include? "uploaded" }

    if !files.empty?
      ticket.save

      files.each do | k,v |
        file = v
        Link.create( filename: file.original_filename, ticket_id: ticket.id, user_id: current_user.id )
        dropbox.upload file.original_filename, file.tempfile
      end
    else
      ticket.save
    end

    redirect_to ticket_index_path
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

  def update
    ticket = Ticket.find( params[ :ticket ][ :ticket_id ] )
    file = params[ :ticket ][ :upload ]

    Link.create( filename: file.original_filename, ticket_id: ticket.id, user_id: current_user.id )
    dropbox.upload file.original_filename, file.tempfile

    dl_search = SDK.search( '/', file.original_filename )[ 0 ][ "path" ]
    path = SDK.media( dl_search )[ "url" ]

    FilesMailer.new_file_notification.new( file.original_filename, path, ticket.user.full_name, ticket.user.email  ).deliver_now

    redirect_to ticket_index_path
  end

  def dl
    if request.xhr?
      ticket = Ticket.find( params[ "ticket" ] )
      dl_search = SDK.search( '/', params[ "dl" ] )[ 0 ][ "path" ]
      path = SDK.media( dl_search )[ "url" ]

      render partial: 'js_response', layout: false, locals: { url: path, ticket_number: ticket.id }
    end
  end

    private

    def ticket_params
      params.require( :ticket ).permit( :user_id, :location, :ticket_number, :body )
    end
end
