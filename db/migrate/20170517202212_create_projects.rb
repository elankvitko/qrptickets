class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.string :location, null: false
      t.string :description
      t.boolean :approved, null:false, default: false
      t.references :user, index: true

      t.timestamps
    end
  end
end
