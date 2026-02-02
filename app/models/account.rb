class Account < ApplicationRecord
  has_many :users
  has_many :call_transcripts
  belongs_to :default_intake_owner, class_name: "User", optional: true

  validates :company_name, presence: true, uniqueness: true
  validates :industry, presence: true
end
