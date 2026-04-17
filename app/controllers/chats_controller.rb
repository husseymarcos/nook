class ChatsController < ApplicationController
  before_action :set_chat, only: %i[ show destroy ]

  DEFAULT_MODEL = "gemini-2.5-flash"

  def index
    @chats = Current.user.chats.reverse_chronologically
  end

  def new
    @chat = Current.user.chats.build
  end

  def create
    if prompt = params.dig(:chat, :prompt).presence
      @chat = Current.user.chats.create!(model: DEFAULT_MODEL)
      @chat.respond_later(prompt)

      redirect_to @chat
    else
      redirect_to new_chat_path
    end
  end

  def show
    @message = @chat.messages.build
  end

  def destroy
    @chat.destroy!
    redirect_to chats_path, notice: "Chat was successfully destroyed.", status: :see_other
  end

  private
    def set_chat
      @chat = Current.user.chats.find(params[:id])
    end
end
