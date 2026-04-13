class Message < ApplicationRecord
  acts_as_message
  has_many_attached :attachments

  broadcasts_to ->(message) { "chat_#{message.chat_id}" }, inserts_by: :append

  validates :role, inclusion: { in: %w[user assistant system tool] }
  validates :content, presence: true, unless: -> { role == "tool" || role == "assistant" }

  # Check if this message is a user message
  def user?
    role == "user"
  end

  # Check if this message is an assistant message
  def assistant?
    role == "assistant"
  end

  # Parse recommendations from assistant message
  def recommendations
    return [] unless assistant?

    # Extract app recommendations using regex
    # Format: "1. **App Name** - Description (Platform) - Pricing"
    content.to_s.scan(/\d+\.\s*\*\*([^*]+)\*\*\s*-\s*([^\(]+)\s*\(([^)]+)\)\s*-\s*(.+)$/).map do |match|
      {
        name: match[0]&.strip,
        description: match[1]&.strip,
        platform: match[2]&.strip,
        pricing: match[3]&.strip
      }
    end.compact
  end

  def broadcast_append_chunk(content)
    broadcast_append_to "chat_#{chat_id}",
      target: "message_#{id}_content",
      content: ERB::Util.html_escape(content.to_s)
  end
end
