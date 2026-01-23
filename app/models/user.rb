class User < ApplicationRecord
  belongs_to :account
  accepts_nested_attributes_for :account
  has_secure_password

  enum :role, { owner: 0, admin: 1, default: 2 }

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
