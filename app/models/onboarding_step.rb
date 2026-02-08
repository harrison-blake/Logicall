class OnboardingStep < ApplicationRecord
  belongs_to :applicant

  validates :title, presence: true
end
