class AddOrderAdminToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :order_admin, :boolean, null: false, default: false
  end
end
