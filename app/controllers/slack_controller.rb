class SlackController < ApplicationController
  before_action :authenticate_user!
  include ApplicationHelper

  def index
    pic = find_me( current_user.email )

    if pic == false
      redirect_to controller: 'users', action: 'edit', id: current_user.id, warning: "redirected"
    else
      current_user.update_attributes( picture_url: pic )
      redirect_to root_path
    end
  end
end
