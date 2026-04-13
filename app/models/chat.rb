class Chat < ApplicationRecord
  acts_as_chat

  def generate_title_from_message(content)
    return if title.present?

    new_title = content.to_s.truncate(30, separator: " ", omission: "")
    new_title = "New Chat" if new_title.blank?
    update(title: new_title)
  end

  def build_context
    messages.order(:created_at).last(10).map do |msg|
      {
        role: msg.role,
        content: msg.content
      }
    end
  end
end
