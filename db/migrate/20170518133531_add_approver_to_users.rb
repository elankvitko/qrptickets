class AddApproverToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :project_approver, :boolean, null: false, default: false
  end
end
