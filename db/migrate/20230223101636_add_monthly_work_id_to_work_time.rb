class AddMonthlyWorkIdToWorkTime < ActiveRecord::Migration[7.0]
  def change
    add_reference :work_times, :monthly_work
  end
end
