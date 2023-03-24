class AddDataToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :monthly_hours, :float
    add_column :users, :is_admin, :boolean
  end
end
