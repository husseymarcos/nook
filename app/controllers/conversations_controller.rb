class ConversationsController < ApplicationController
  before_action :require_authentication
  before_action :set_conversation, only: [ :show, :destroy, :update_title ]

  def index
    @conversations = Current.user.conversations.order(updated_at: :desc)
  end

  def show
    @messages = @conversation.messages.order(:created_at)
    @message = Message.new
  end

  def new
    @conversation = Current.user.conversations.create!(title: "New Conversation")
    redirect_to @conversation
  end

  def create
    @conversation = Current.user.conversations.build(conversation_params)

    if @conversation.save
      redirect_to @conversation
    else
      redirect_to conversations_path, alert: "Could not create conversation"
    end
  end

  def destroy
    @conversation.destroy
    redirect_to conversations_path, notice: "Conversation deleted"
  end

  def update_title
    if @conversation.update(title: params[:title])
      render json: { success: true }
    else
      render json: { success: false, errors: @conversation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_conversation
    @conversation = Current.user.conversations.find(params[:id])
  end

  def conversation_params
    params.require(:conversation).permit(:title)
  end
end
