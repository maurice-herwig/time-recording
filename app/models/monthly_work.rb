class MonthlyWork < ApplicationRecord
  validates :year, presence: true
  validates :month, presence: true

  belongs_to :user, optional: false
  has_many :work_times, dependent: :delete_all

  def date
    "#{month}. #{year}"
  end

end
