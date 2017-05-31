class AddExcelAdmingToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :excel_admin, :boolean, null: false, default: false
  end
end
