class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @inbox = mailbox.inbox
    @active = :inbox
    @unread_conversations = []

    @inbox.each do | mail |
      if mail.is_unread?(current_user)
        @unread_conversations << mail
      end
    end

    @unread = mailbox.inbox(:unread => true).count
    @level_1 = Ticket.where( "level = '1'" ).length
    @level_2 = Ticket.where( "level = '2'" ).length
    @level_3 = Ticket.where( "level = '3'" ).length
    @not_viewed = Ticket.where( "viewed = false" ).length
  end
end
