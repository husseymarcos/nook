class ChatsController < ApplicationController
  before_action :set_chat, only: [ :show, :destroy ]

  DEFAULT_MODEL="gemini-2.5-flash"

  def index
    @chats = Chat.order(created_at: :desc)
  end

  def new
    @chat = Chat.new
  end

  def create
    prompt = params.dig(:chat, :prompt)
    if prompt.present?
      @chat = Chat.create!(model: DEFAULT_MODEL)
      ChatResponseJob.perform_later(@chat.id, prompt)

      redirect_to @chat, notice: "Chat was successfully created."
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
    @chat = Chat.find(params[:id])
  end
end
