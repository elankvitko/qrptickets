class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @level_1 = Ticket.where( "level = '1'" ).length
    @level_2 = Ticket.where( "level = '2'" ).length
    @level_3 = Ticket.where( "level = '3'" ).length
    @not_viewed = Ticket.where( "viewed = false" ).length
  end
end
