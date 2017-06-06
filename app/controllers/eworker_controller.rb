class EworkerController < ApplicationController
  require 'csv'
  require 'open-uri'
  include TicketHelper

  def index
    if !current_user.excel_admin?
      redirect_to root_path
    end

    @unread = mailbox.inbox(:unread => true).count
    @csvlocation = Csvlocation.new()

    @filenames = Csvlocation.where( user_id: current_user.id )
  end

  def show
    dl_search = SDK.search( '/', params[ "filename" ] )[ 0 ][ "path" ]
    path = SDK.media( dl_search )[ "url" ]
    @all_cell_blocks = []

    download = open( path )
    IO.copy_stream( download, "temp.csv" )

    CSV.foreach( "temp.csv", headers:true ) do | dl |
      @all_cell_blocks << dl.to_h
    end

    $all_cells = @all_cell_blocks

    render :js => "window.location = '#{ csvlocation_path( params[ 'id' ] ) }'"
  end
end
