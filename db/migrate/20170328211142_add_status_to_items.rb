class AddStatusToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :status, :string, null: false, default: "Requested"
  end
end
