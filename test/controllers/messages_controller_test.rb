require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  test "creates message in chat" do
    chat = chats(:one)

    assert_enqueued_with(job: ChatResponseJob) do
      post chat_messages_url(chat), params: { message: { content: "Hello" } }, as: :turbo_stream
    end
    assert_response :success
  end

  test "requires authentication" do
    chat = chats(:one)
    sign_out
    post chat_messages_url(chat), params: { message: { content: "Hello" } }, as: :turbo_stream
    assert_redirected_to new_session_path
  end

  test "requires content" do
    chat = chats(:one)

    assert_no_enqueued_jobs only: ChatResponseJob do
      post chat_messages_url(chat), params: { message: { content: "" } }, as: :turbo_stream
    end
    assert_response :success
  end
end
