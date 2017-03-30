class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit
    @unread = mailbox.inbox(:unread => true).count
    @user = current_user

    if params[ "warning" ]
      @warning = "We couldn't find an active slack account for Quick RX or Cure Urgent Care using your email. Please contact an administrator to get invited to Slack and then link your avatar, or you may upload one below!"
    end
  end

  def update
    @user = current_user

    uploaded_io = params[ :user ][ :picture ]

    file = File.open( Rails.root.join('public', 'uploads', uploaded_io.original_filename ), 'wb' ) do |file|
      file.write( uploaded_io.read )
    end

    @user.update_attributes( picture_url: upload_pic( uploaded_io.original_filename ) )

    redirect_to root_path
  end
end
