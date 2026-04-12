require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  test "creates message in conversation" do
    conversation = conversations(:one)

    assert_difference "Message.count", 1 do
      post conversation_messages_url(conversation), params: { message: { content: "Hello" } }
    end
    assert_redirected_to conversation_path(conversation)
  end

  test "blocks free users over monthly limit" do
    user = Current.user
    user.update!(searches_this_month: 10, last_search_reset_at: Time.current)
    conversation = conversations(:one)

    post conversation_messages_url(conversation), params: { message: { content: "I need recommendations" } }
    assert_redirected_to billing_index_path
  end

  test "allows free users under monthly limit" do
    user = Current.user
    user.update!(searches_this_month: 5, last_search_reset_at: Time.current)
    conversation = conversations(:one)

    post conversation_messages_url(conversation), params: { message: { content: "I need recommendations" } }
    assert_redirected_to conversation_path(conversation)
  end

  test "allows premium users regardless of limit" do
    user = Current.user
    user.update!(searches_this_month: 100, premium_until: 1.month.from_now)
    conversation = conversations(:one)

    post conversation_messages_url(conversation), params: { message: { content: "I need recommendations" } }
    assert_redirected_to conversation_path(conversation)
  end

  test "generates conversation title from first message" do
    conversation = conversations(:four)

    post conversation_messages_url(conversation), params: { message: { content: "I need a calendar app" } }
    assert_equal "I need a calendar app", conversation.reload.title
  end

  test "requires authentication" do
    conversation = conversations(:one)
    sign_out
    post conversation_messages_url(conversation), params: { message: { content: "Hello" } }
    assert_redirected_to new_session_path
  end

  test "prevents messages in other users' conversations" do
    post conversation_messages_url(conversations(:three)), params: { message: { content: "Hello" } }
    assert_response :not_found
  end
end
