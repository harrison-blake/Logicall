class CallTranscript < ApplicationRecord
  belongs_to :account

  enum :status, { completed: 0, failed: 1 }
end
