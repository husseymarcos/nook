class MessagesController < ApplicationController
  before_action :require_authentication
  before_action :set_conversation
  before_action :check_rate_limit, only: [ :create ]

  def create
    @message = @conversation.messages.build(message_params.merge(role: "user"))

    if @message.save
      # Update conversation title on first message
      @conversation.generate_title_from_message(@message.content) if @conversation.messages.count == 1

      # Increment search count if this is a user asking for recommendations
      # (not just answering follow-up questions)
      increment_search_if_recommendation_request

      # Generate AI response
      GenerateAiResponseJob.perform_later(@conversation, Current.user)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @conversation }
      end
    else
      render @conversation, status: :unprocessable_entity
    end
  end

  private

  def set_conversation
    @conversation = Current.user.conversations.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def check_rate_limit
    unless Current.user.can_search?
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append("messages", partial: "conversations/upgrade_prompt")
        end
        format.html { redirect_to billing_index_path, alert: "You've reached your free search limit. Upgrade to continue." }
      end
    end
  end

  def increment_search_if_recommendation_request
    # Simple heuristic: if message contains recommendation keywords
    # and conversation has less than 4 messages, count as search
    keywords = %w[recommend app tool software looking for need help with suggest]
    if keywords.any? { |k| @message.content.downcase.include?(k) } && @conversation.messages.count <= 4
      Current.user.increment_search_count!
    end
  end
end
