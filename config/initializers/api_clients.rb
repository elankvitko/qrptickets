require "slack"
require 'dropbox_sdk'

SLACK = Slack::Client.new token: ENV[ "SLACK" ]

USERS = SLACK.users_list[ "members" ].select { |obj| obj[ 'profile' ] }

SDK = DropboxClient.new( ENV[ "DROPBOX_KEY_BASE" ] )
