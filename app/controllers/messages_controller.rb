class MessagesController < ApplicationController
  before_action :set_chat

  def create
    if content = params.dig(:message, :content).presence
      @chat.respond_later(content)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @chat }
      end
    else
      head :ok
    end
  end

  private
    def set_chat
      @chat = Chat.find(params[:chat_id])
    end
end
