require "slack"

SLACK = Slack::Client.new token: ENV[ "SLACK" ]

USERS = SLACK.users_list[ "members" ].select { |obj| obj[ 'profile' ] }
