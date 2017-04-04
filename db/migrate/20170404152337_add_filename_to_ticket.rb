class AddFilenameToTicket < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :filename, :string
  end
end
