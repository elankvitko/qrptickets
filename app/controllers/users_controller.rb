class UsersController < ApplicationController
  def edit
    @user = current_user
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
