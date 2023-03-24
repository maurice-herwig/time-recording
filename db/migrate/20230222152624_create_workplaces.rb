class CreateWorkplaces < ActiveRecord::Migration[7.0]
  def change
    create_table :workplaces do |t|
      t.string :name
      t.string :street_name
      t.string :street_number
      t.string :city
      t.integer :zip_code

      t.timestamps
    end
  end
end
