class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.string :location, null: false
      t.string :qty, null: false
      t.references :user, index: true

      t.timestamps
    end
  end
end
