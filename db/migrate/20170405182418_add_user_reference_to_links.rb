class AddUserReferenceToLinks < ActiveRecord::Migration[5.0]
  def change
    add_reference :links, :user, index: true
  end
end
