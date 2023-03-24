class AddWorkplaceIdToWorkTime < ActiveRecord::Migration[7.0]
  def change
    add_reference :work_times, :workplace
  end
end
