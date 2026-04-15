require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "creates message with role and content" do
    message = messages(:one)
    assert message.valid?
    assert_equal "user", message.role
    assert message.content.present?
  end

  test "requires content for user role" do
    message = Message.new(role: "user", chat: chats(:one))
    assert_not message.valid?
    assert_includes message.errors[:content], "can't be blank"
  end

  test "does not require content for assistant role" do
    message = Message.new(role: "assistant", chat: chats(:one))
    assert message.valid?
  end

  test "does not require content for tool role" do
    message = Message.new(role: "tool", chat: chats(:one))
    assert message.valid?
  end

  test "only allows valid roles" do
    message = Message.new(
      role: "invalid",
      content: "test content",
      chat: chats(:one)
    )
    assert_not message.valid?
    assert_includes message.errors[:role], "is not included in the list"
  end

  test "identifies user messages" do
    assert messages(:one).user?
    assert_not messages(:one).assistant?
  end

  test "identifies assistant messages" do
    assert messages(:two).assistant?
    assert_not messages(:two).user?
  end

  test "identifies system messages" do
    message = Message.new(role: "system", chat: chats(:one))
    assert message.system?
  end

  test "identifies tool messages" do
    message = Message.new(role: "tool", chat: chats(:one))
    assert message.tool?
  end
end
