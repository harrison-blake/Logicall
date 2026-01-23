class User < ApplicationRecord
  belongs_to :account
  accepts_nested_attributes_for :account
  has_secure_password

  enum :role, { owner: 0, admin: 1, staff: 2 }

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  def generate_password_reset_token!
    update!(
      password_reset_token: SecureRandom.urlsafe_base64,
      password_reset_sent_at: Time.current
    )
  end
end
