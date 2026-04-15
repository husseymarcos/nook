require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "user message requires content" do
    message = Message.new(role: "user", chat: chats(:one))
    assert_not message.valid?
    assert_includes message.errors[:content], "can't be blank"

    message.content = "Hello, I need help"
    assert message.valid?
  end

  test "assistant message can be created without content for streaming" do
    message = Message.new(role: "assistant", chat: chats(:one))
    assert message.valid?, "Assistant message should be valid without content"
  end

  test "only valid message roles are accepted" do
    message = Message.new(role: "invalid_role", content: "test", chat: chats(:one))
    assert_not message.valid?
    assert_includes message.errors[:role], "is not included in the list"
  end

  test "message is associated with its chat" do
    message = messages(:one)
    chat = chats(:one)

    assert_equal chat, message.chat
    assert_includes chat.messages, message
  end

  test "message knows if it is from a user" do
    user_message = messages(:one)
    assistant_message = messages(:two)

    assert user_message.from_user?
    assert_not assistant_message.from_user?
  end

  test "message knows if it is from an assistant" do
    user_message = messages(:one)
    assistant_message = messages(:two)

    assert assistant_message.from_assistant?
    assert_not user_message.from_assistant?
  end

  test "assistant message can contain tool recommendations" do
    recommendation_message = messages(:three)

    assert recommendation_message.from_assistant?
    assert recommendation_message.has_recommendations?
    assert_equal 3, recommendation_message.recommendations.count

    first_rec = recommendation_message.recommendations.first
    assert_equal "Notion", first_rec[:name]
    assert_equal "All-in-one workspace", first_rec[:description]
    assert_equal "Web", first_rec[:platform]
    assert_equal "Freemium", first_rec[:pricing]
  end

  test "user messages never have recommendations" do
    user_message = messages(:one)

    assert user_message.from_user?
    assert_not user_message.has_recommendations?
    assert_empty user_message.recommendations
  end

  test "assistant message without recommendations returns empty list" do
    simple_assistant_message = messages(:two)

    assert simple_assistant_message.from_assistant?
    assert_not simple_assistant_message.has_recommendations?
    assert_empty simple_assistant_message.recommendations
  end

  test "content can be split into narrative and recommendations" do
    message = messages(:three)

    narrative = message.content_without_recommendations
    assert_equal "Here are my recommendations:", narrative

    recommendations = message.recommendations
    assert_equal 3, recommendations.count
  end
end
