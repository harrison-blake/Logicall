class Account < ApplicationRecord
  has_many :users

  validates :company_name, presence: true, uniqueness: true
  validates :industry, presence: true
end
