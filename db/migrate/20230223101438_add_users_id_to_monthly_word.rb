class AddUsersIdToMonthlyWord < ActiveRecord::Migration[7.0]
  def change
    add_reference :monthly_works, :user
  end
end
