class Message < ApplicationRecord
  belongs_to :conversation

  validates :role, inclusion: { in: %w[user assistant] }
  validates :content, presence: true

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
    content.scan(/\d+\.\s*\*\*([^*]+)\*\*\s*-\s*([^\(]+)\s*\(([^)]+)\)\s*-\s*(.+)$/).map do |match|
      {
        name: match[0]&.strip,
        description: match[1]&.strip,
        platform: match[2]&.strip,
        pricing: match[3]&.strip
      }
    end.compact
  end
end
