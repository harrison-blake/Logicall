class User < ApplicationRecord
  belongs_to :account
  has_many :intakes
  has_many :assistant_logs
  has_one :applicant_profile, class_name: "Applicant", dependent: :destroy
  accepts_nested_attributes_for :account
  has_secure_password

  generates_token_for :password_reset, expires_in: 24.hours do
    password_salt&.last(10)
  end

  enum :role, { owner: 0, admin: 1, staff: 2, applicant: 3 }

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
