module TicketHelper
  def dropbox
    Dropbox::API::Config.app_key = ENV[ "DROPBOX_APP_KEY" ]
    Dropbox::API::Config.app_secret = ENV[ "DROPBOX_SECRET_KEY" ]
    Dropbox::API::Config.mode = "dropbox"
    @client = Dropbox::API::Client.new( :token  => ENV[ "DROPBOX_TOKEN" ], :secret => ENV[ "DROPBOX_SECRET_TOKEN" ] )
  end
end
