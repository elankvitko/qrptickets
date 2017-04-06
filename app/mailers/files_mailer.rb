class FilesMailer < ApplicationMailer
  def new_file_notification( filename, url, name, email )
    @filename = filename
    @url = url
    @name = name
    @email = email

    mail to: @email,
         subject: "You've Got Files"
  end
end
