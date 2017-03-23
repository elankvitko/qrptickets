class AddStatusToTicket < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :status, :string, null: false, default: "In Queue"
  end
end
