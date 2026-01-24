class Intake < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  enum :status, { pending: 0, reviewed: 1 }
end
