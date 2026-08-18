class Chat < ApplicationRecord
  DEFAULT_TITLE = "Untitled"

  TITLE_PROMPT = <<~PROMPT
    Generate a short title for this conversation.
    Return only the title.
  PROMPT

  belongs_to :user
  has_many :messages

  validates :title, length: { maximum: 120 }, allow_blank: true

  def generate_title_from_first_message
    return unless title == DEFAULT_TITLE

    first_user_message = messages.where(role: "user").order(:created_at).first
    return if first_user_message.nil?

    response = RubyLLM.chat.with_instructions(TITLE_PROMPT).ask(first_user_message.content)
    update(title: response.content)
  end
end
