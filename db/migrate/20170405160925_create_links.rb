class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.string :filename, null: false
      t.references :ticket, index: true

      t.timestamps
    end
  end
end
