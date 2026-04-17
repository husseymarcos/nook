class ChatResponseJob < ApplicationJob
  def perform(chat_id, prompt)
    Chat.find(chat_id).respond_now(prompt)
  end
end
