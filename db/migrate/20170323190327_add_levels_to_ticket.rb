class AddLevelsToTicket < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :level, :string, null: false, default: '1'
    add_column :tickets, :viewed, :boolean, null: false, default: false
  end
end
