class CsvlocationsController < ApplicationController
  include TicketHelper
  include EworkerHelper
  require 'csv'

  def create
    if params[ 'compare-type' ] == 'pb'
      billing_file = params[ "billing_filename" ]
      purchasing_file = params[ "purchasing_filename" ]

      dropbox.upload billing_file.original_filename, billing_file.tempfile
      dropbox.upload purchasing_file.original_filename, purchasing_file.tempfile

      ul_search_billing = SDK.search( '/', billing_file.original_filename )[ 0 ][ "path" ]
      path_billing = SDK.media( ul_search_billing )[ "url" ]

      ul_search_purchasing = SDK.search( '/', purchasing_file.original_filename )[ 0 ][ "path" ]
      path_purchasing = SDK.media( ul_search_purchasing )[ "url" ]

      upload_billing = open( path_billing )
      upload_purchasing = open( path_purchasing )


      IO.copy_stream( upload_billing, "billing.csv" )
      IO.copy_stream( upload_purchasing, "purchasing.csv" )

      compare_pb

      file = File.join( Rails.root, 'file.csv' )
      dropbox.upload( 'Controls_Comparison.csv', File.read( file ) )
    end

    dl_search = SDK.search( '/', "Controls_Comparison.csv" )[ 0 ][ "path" ]
    path = SDK.media( dl_search )[ "url" ]
    # redirect_to eworker_index_path
    redirect_to controller: 'eworker', action: 'index', dl: path
  end

  def show
    @unread = mailbox.inbox(:unread => true).count
    @cell_blocks = $all_cells
  end
end
