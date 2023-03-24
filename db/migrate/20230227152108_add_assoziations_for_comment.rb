class AddAssoziationsForComment < ActiveRecord::Migration[7.0]
  def change
    add_reference :comments, :work_time
    add_reference :comments, :user
  end
end
