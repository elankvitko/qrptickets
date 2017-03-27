class MailboxController < ApplicationController
  before_action :authenticate_user!

  def inbox
    @inbox = mailbox.inbox
    @active = :inbox
    @unread = mailbox.inbox(:unread => true).count
  end

  def sent
    @sent = mailbox.sentbox
    @active = :sent
    @unread = mailbox.inbox(:unread => true).count
  end

  def trash
    @trash = mailbox.trash
    @active = :trash
    @unread = mailbox.inbox(:unread => true).count
  end
end
