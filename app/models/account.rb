class Account < ApplicationRecord
  has_many :users
  has_many :call_transcripts
  has_many :default_onboarding_steps
  belongs_to :default_intake_owner, class_name: "User", optional: true

  validates :company_name, presence: true, uniqueness: true
  validates :industry, presence: true

  def gemini_configured?
    resolved_gemini_key.present?
  end

  def telnyx_configured?
    resolved_telnyx_key.present?
  end

  def resolved_gemini_key
    gemini_api_key.presence || Rails.application.credentials.dig(:gemini, :api_key)
  end

  def resolved_telnyx_key
    telnyx_api_key.presence || Rails.application.credentials.dig(:telnyx, :api_key)
  end
end
