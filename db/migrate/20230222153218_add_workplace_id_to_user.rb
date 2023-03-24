class AddWorkplaceIdToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :workplace
  end
end
