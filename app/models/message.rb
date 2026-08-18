class Message < ApplicationRecord
  # Roles attendus par les APIs de LLM.
  ROLES = %w[user assistant system].freeze

  belongs_to :chat

  validates :content, presence: true
  validates :role, presence: true, inclusion: { in: ROLES }
end
