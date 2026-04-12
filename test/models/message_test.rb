require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "creates message with role and content" do
    message = messages(:one)
    assert message.valid?
    assert_equal "user", message.role
    assert message.content.present?
  end

  test "requires content" do
    message = Message.new(role: messages(:one).role, conversation: messages(:one).conversation)
    assert_not message.valid?
    assert_includes message.errors[:content], "can't be blank"
  end

  test "only allows user or assistant roles" do
    message = Message.new(
      role: "invalid",
      content: messages(:one).content,
      conversation: messages(:one).conversation
    )
    assert_not message.valid?
    assert_includes message.errors[:role], "is not included in the list"
  end

  test "identifies user messages" do
    assert messages(:one).user?
  end

  test "identifies assistant messages" do
    assert messages(:two).assistant?
  end

  test "does not extract recommendations from user messages" do
    assert_empty messages(:one).recommendations
  end

  test "extracts app recommendations from assistant responses" do
    recs = messages(:three).recommendations

    assert_equal 3, recs.length
    assert_equal "Notion", recs[0][:name]
    assert_equal "All-in-one workspace", recs[0][:description]
    assert_equal "Web", recs[0][:platform]
    assert_equal "Freemium", recs[0][:pricing]
  end

  test "returns empty recommendations when none found" do
    assert_empty messages(:two).recommendations
  end

  test "requires complete recommendation format" do
    assert_empty messages(:four).recommendations
  end
end
