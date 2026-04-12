class Conversation < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy

  validates :title, presence: true

  # Auto-generate title from first user message if not set
  def generate_title_from_message(content)
    return if title.present? && title != "New Conversation"

    # Use first 30 chars of first message
    new_title = content.to_s.truncate(30, separator: " ", omission: "")
    new_title = "New Conversation" if new_title.blank?
    update(title: new_title)
  end

  # Build context for LLM (last 10 messages)
  def build_context
    messages.order(:created_at).last(10).map do |msg|
      {
        role: msg.role,
        content: msg.content
      }
    end
  end
end
