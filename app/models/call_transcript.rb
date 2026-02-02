class CallTranscript < ApplicationRecord
  belongs_to :account
  belongs_to :intake, optional: true

  enum :status, { completed: 0, failed: 1 }
end
