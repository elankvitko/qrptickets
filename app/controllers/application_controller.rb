class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :mailbox, :conversation

  def after_sign_in_path_for(resource)
    root_path
  end

  def upload_pic( image )
    image = Cloudinary::Uploader.upload( Rails.root.join( 'public', 'uploads', image ) )
    image[ 'url' ]
  end

  private

  def mailbox
    @mailbox ||= current_user.mailbox
  end

  def conversation
    @conversation ||= mailbox.conversations.find(params[:id])
  end

  protected
end
