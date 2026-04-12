require "test_helper"

class ConversationTest < ActiveSupport::TestCase
  test "creates conversation with title and user" do
    conversation = Conversation.new(
      title: "Test Chat",
      user: users(:one)
    )
    assert conversation.valid?
  end

  test "requires title" do
    conversation = Conversation.new(user: users(:one))
    assert_not conversation.valid?
    assert_includes conversation.errors[:title], "can't be blank"
  end

  test "belongs to user" do
    conversation = conversations(:one)
    assert_equal users(:one), conversation.user
  end

  test "has many messages" do
    conversation = conversations(:one)
    assert_respond_to conversation, :messages
  end

  test "sets title from first message" do
    conversation = conversations(:four)
    conversation.generate_title_from_message("I need a project management tool")

    assert_equal "I need a project management", conversation.title
  end

  test "truncates long message titles" do
    conversation = conversations(:four)
    long_content = "A" * 50
    conversation.generate_title_from_message(long_content)

    title = conversation.reload.title
    assert_not_nil title
    assert_operator title.length, :<, 50
  end

  test "preserves custom titles" do
    conversation = conversations(:one)
    conversation.generate_title_from_message("New content")

    assert_equal "New Tool for Project Management", conversation.title
  end

  test "builds conversation context from recent messages" do
    conversation = conversations(:one)
    12.times do |i|
      conversation.messages.create!(role: i.even? ? "user" : "assistant", content: "Message #{i}")
    end

    context = conversation.build_context

    assert_equal 10, context.length
    assert context.all? { |m| m[:role].present? && m[:content].present? }
  end
end
