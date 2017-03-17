class ContactController < ApplicationController
  def create
    if request.xhr?
      @ticket = Ticket.create( ticket_number: params[ 'ticket_number' ], name: params[ 'name' ], email: params[ 'email' ], facility: params[ 'facility' ], body: params[ 'body' ] )

      session = GoogleDrive::Session.from_config("config.json")
      ws = session.spreadsheet_by_key("1aYKq_4dC24KbZsM7oG76ziVE0hXnQLJUzf1PI5etks4").worksheets[0]
      idx = ws.rows.count + 1
      val_idx = 1

      @ticket.attributes.each do | key, val |
        next if key == "id"
        break if key == "created_at"

        if key == 'body'
          skip_idx = val_idx + 1
          ws[ idx, skip_idx ] = val
        elsif key == 'facility'
          prev_idx = val_idx - 1
          ws[ idx, prev_idx ] = val
        elsif key == 'ticket_number'
          ws[ idx, val_idx ] = idx + 4
        else
          ws[ idx, val_idx ] = val
        end

        val_idx += 1
      end

      ws.save

      ContactMailer.new_contact( params[ 'ticket_number' ], params[ 'name' ], params[ 'email' ], params[ 'facility' ], params[ 'body' ] ).deliver_now
      render partial:'success', layout: false
    end
  end
end
