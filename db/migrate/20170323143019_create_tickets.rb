class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.string :ticket_number, null: false
      t.string :location, null: false
      t.text :body, null: false
      t.references :user, index: true

      t.timestamps
    end
  end
end
