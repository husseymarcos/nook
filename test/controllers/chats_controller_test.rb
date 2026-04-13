require "test_helper"

class ChatsControllerTest < ActionDispatch::IntegrationTest
  test "lists chats" do
    get chats_url
    assert_response :success
  end

  test "shows chat" do
    chat = chats(:one)
    get chat_url(chat)
    assert_response :success
  end

  test "creates new chat" do
    assert_enqueued_with(job: ChatResponseJob) do
      post chats_url, params: { chat: { prompt: "Test message", model: "gpt-4o" } }
    end
    assert_redirected_to chat_path(Chat.last)
  end

  test "deletes chat" do
    chat = chats(:one)
    assert_difference "Chat.count", -1 do
      delete chat_url(chat)
    end
    assert_redirected_to chats_path
  end

  test "requires authentication for index" do
    sign_out
    get chats_url
    assert_redirected_to new_session_path
  end

  test "requires authentication for show" do
    sign_out
    get chat_url(chats(:one))
    assert_redirected_to new_session_path
  end
end
