class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.string :ticket_number, unique: true
      t.string :name
      t.string :email
      t.string :body
      t.string :facility

      t.timestamps
    end
  end
end
