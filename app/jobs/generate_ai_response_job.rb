class GenerateAiResponseJob < ApplicationJob
  queue_as :default

  def perform(conversation, user)
    service = GeminiService.new
    response_content = service.generate_response(conversation, user)

    # Create the assistant message
    conversation.messages.create!(
      role: "assistant",
      content: response_content
    )

    # Broadcast to the conversation using Turbo Streams
    Turbo::StreamsChannel.broadcast_append_to(
      conversation,
      target: "messages",
      partial: "messages/message",
      locals: { message: conversation.messages.last }
    )

    # Remove typing indicator if present
    Turbo::StreamsChannel.broadcast_remove_to(
      conversation,
      target: "typing-indicator"
    )
  rescue StandardError => e
    Rails.logger.error "AI Response generation failed: #{e.message}"

    # Create error message
    conversation.messages.create!(
      role: "assistant",
      content: "Sorry, I encountered an error. Please try again."
    )

    Turbo::StreamsChannel.broadcast_append_to(
      conversation,
      target: "messages",
      partial: "messages/message",
      locals: { message: conversation.messages.last }
    )
  end
end
