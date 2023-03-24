class CreateWorkTimes < ActiveRecord::Migration[7.0]
  def change
    create_table :work_times do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :striking

      t.timestamps
    end
  end
end
