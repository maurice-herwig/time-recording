class CreateMonthlyWorks < ActiveRecord::Migration[7.0]
  def change
    create_table :monthly_works do |t|
      t.integer :month
      t.integer :year

      t.timestamps
    end
  end
end
