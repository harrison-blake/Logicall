class Task < ApplicationRecord
  belongs_to :intake

  enum :status, { pending: 0, completed: 1 }
end
