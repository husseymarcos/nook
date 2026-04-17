class Chat < ApplicationRecord
  CONTEXT_WINDOW = 10
  TITLE_LENGTH = 30

  acts_as_chat

  scope :reverse_chronologically, -> { order(created_at: :desc) }

  def respond_later(prompt)
    ChatResponseJob.perform_later(id, prompt)
  end

  def respond_now(prompt)
    with_instructions(system_prompt)
    ask(prompt) do |chunk|
      if chunk.content.present?
        messages.last.broadcast_append_chunk(chunk.content)
      end
    end
  end

  def generate_title_from_message(content)
    if title.blank?
      update(title: title_from(content))
    end
  end

  def build_context
    messages.chronologically.last(CONTEXT_WINDOW).map do |message|
      { role: message.role, content: message.content }
    end
  end

  private
    def system_prompt
      Rails.root.join("config/prompts/system_prompt.md").read
    end

    def title_from(content)
      truncated = content.to_s.truncate(TITLE_LENGTH, separator: " ", omission: "")
      truncated.presence || "New Chat"
    end
end
