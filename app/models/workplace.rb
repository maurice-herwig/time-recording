class Workplace < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :street_name, presence: true
  validates :street_number, presence: true
  validates :city, presence: true
  validates :zip_code, presence:  true

  has_many :user, dependent: :restrict_with_exception
  has_many :work_times, dependent: :restrict_with_exception

  def address
    "#{street_name} #{street_number}, #{zip_code} #{city}"
  end
end
