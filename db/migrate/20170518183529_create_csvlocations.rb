class CreateCsvlocations < ActiveRecord::Migration[5.0]
  def change
    create_table :csvlocations do |t|
      t.string :billing_filename, null: false
      t.string :purchasing_filename, null: false
      t.references :user, index: true

      t.timestamps
    end
  end
end
