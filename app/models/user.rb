class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable, #:recoverable,
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable

  after_initialize :set_defaults

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, uniqueness: true, allow_blank: true, format: { with: /\A\S+@.+\.\S+\z/ }
  validates :monthly_hours, presence: true
  validates :is_admin, inclusion: [true, false]

  has_secure_password :personal_secret

  belongs_to :workplace, optional: false
  has_many :monthly_works, dependent: :delete_all
  has_many :comments, dependent: :delete_all

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
    attachable.variant :microthumb, resize_to_limit: [50, 50]
  end

  def set_defaults
    # Set the defaults of a new registered user.
    self.is_admin ||= false
    self.monthly_hours ||= 0

    # if no workplace present Create a new workplace with the name "Users without workplaces".
    unless self.workplace.present?
      workplace = Workplace.find_or_create_by(name: "Users without workplaces",
                                              street_name: '-',
                                              street_number: '-',
                                              city: '-',
                                              zip_code: 0)
      workplace.save!
      self.workplace = workplace
    end

  end

  def is_personal_secret_valid?(secret)
    # Create a BCrypt object
    personal_secret = BCrypt::Password.new(personal_secret_digest)

    # Check if the secret correct
    (personal_secret == secret)
  end

  def name
    "#{firstname} #{lastname}"
  end

  def admin?
    is_admin
  end

end
