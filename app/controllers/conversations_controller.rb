class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @unread = mailbox.inbox(:unread => true).count
  end

  def create
    @unread = mailbox.inbox(:unread => true).count
    recipients = User.where(id: conversation_params[:recipients])
    conversation = current_user.send_message(recipients, conversation_params[:body], conversation_params[:subject]).conversation
    flash[:success] = "Your message was successfully sent!"
    name = conversation.recipients.select { |obj| obj != current_user }[ 0 ].full_name
    email = conversation.recipients.select { |obj| obj != current_user }[ 0 ].email
    NotificationMailer.new_notification( name, email ).deliver_now
    redirect_to conversation_path(conversation)
  end

  def show
    if params[ "sent" ]
      @tagger = true
    end

    @unread = mailbox.inbox(:unread => true).count
    @receipts = conversation.receipts_for(current_user).reverse
    # mark conversation as read
    conversation.mark_as_read(current_user)
    @receipts = @receipts.sort_by {|item| item.created_at}
  end

  def reply
    @unread = mailbox.inbox(:unread => true).count
    current_user.reply_to_conversation(conversation, message_params[:body])
    flash[:notice] = "Your reply message was successfully sent!"
    name = conversation.recipients.select { |obj| obj != current_user }[ 0 ].full_name
    email = conversation.recipients.select { |obj| obj != current_user }[ 0 ].email
    NotificationMailer.new_notification( name, email ).deliver_now
    redirect_to conversation_path(conversation)
  end

  def trash
    @unread = mailbox.inbox(:unread => true).count
    conversation.move_to_trash(current_user)
    redirect_to mailbox_inbox_path
  end

  def untrash
    @unread = mailbox.inbox(:unread => true).count
    conversation.untrash(current_user)
    redirect_to mailbox_inbox_path
  end


  private

  def conversation_params
    params.require(:conversation).permit(:subject, :body, :recipients)
  end

  def message_params
    params.require(:message).permit(:body, :subject)
  end
end
