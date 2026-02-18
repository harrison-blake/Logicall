class Applicant < ApplicationRecord
  belongs_to :user
  has_many :onboarding_steps, dependent: :destroy
  has_many_attached :attachments

  enum :status, { applied: 0, screening: 1, interview: 2, offer: 3, hired: 4, rejected: 5 }

  validates :position, presence: true
end
