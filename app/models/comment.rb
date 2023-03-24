class Comment < ApplicationRecord
  validates :comment, presence: true

  belongs_to :work_time, optional: false
  belongs_to :user, optional: false
end
