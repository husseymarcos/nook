require "test_helper"

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  test "lists user's conversations" do
    get conversations_url
    assert_response :success
  end

  test "shows conversation to owner" do
    conversation = conversations(:one)
    get conversation_url(conversation)
    assert_response :success
  end

  test "creates new conversation" do
    post conversations_url, params: { conversation: { title: "Test" } }
    assert_redirected_to conversation_path(Conversation.last)
  end

  test "deletes conversation" do
    conversation = conversations(:one)
    assert_difference "Conversation.count", -1 do
      delete conversation_url(conversation)
    end
    assert_redirected_to conversations_path
  end

  test "updates conversation title" do
    conversation = conversations(:one)
    patch update_title_conversation_url(conversation), params: { title: "New Title" }, as: :json
    assert_response :success
    assert_equal "New Title", conversation.reload.title
  end

  test "requires authentication for index" do
    sign_out
    get conversations_url
    assert_redirected_to new_session_path
  end

  test "requires authentication for show" do
    sign_out
    get conversation_url(conversations(:one))
    assert_redirected_to new_session_path
  end

  test "prevents access to other users' conversations" do
    get conversation_url(conversations(:three))
    assert_response :not_found
  end
end
