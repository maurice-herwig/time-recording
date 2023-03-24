class WorkTime < ApplicationRecord
  validates :start_time, presence: false
  validates :end_time, presence: false
  validates :striking, presence:false, inclusion: [true, false]

  belongs_to :monthly_work, optional: false
  belongs_to :workplace, optional: false
  has_many :comments, dependent: :delete_all
end
