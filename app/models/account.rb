class Account < ApplicationRecord
  has_many :users
  has_many :call_transcripts

  validates :company_name, presence: true, uniqueness: true
  validates :industry, presence: true
end
