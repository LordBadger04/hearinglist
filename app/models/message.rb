class Message < ApplicationRecord
  # Roles attendus par les APIs de LLM.
  ROLES = %w[user assistant system].freeze

  belongs_to :chat

  validates :content, presence: true
  validates :role, presence: true, inclusion: { in: ROLES }

  MAX_USER_MESSAGES = 10

  validate :user_message_limit, if: -> { role == "user" }

  private

  def user_message_limit
    if chat.messages.where(role: "user").count >= MAX_USER_MESSAGES
      errors.add(
        :content,
        "You can only send #{MAX_USER_MESSAGES} messages per chat."
      )
    end
  end
end
