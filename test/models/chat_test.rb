require "test_helper"

class ChatTest < ActiveSupport::TestCase
  test "creates chat with title" do
    chat = Chat.new(title: "Test Chat")
    assert chat.valid?
  end

  test "has many messages" do
    chat = chats(:one)
    assert_respond_to chat, :messages
  end

  test "sets title from first message" do
    chat = chats(:four)
    chat.generate_title_from_message("I need a project management tool")

    assert chat.title.present?
    assert chat.title.starts_with?("I need a")
  end

  test "truncates long message titles" do
    chat = chats(:four)
    long_content = "A" * 50
    chat.generate_title_from_message(long_content)

    title = chat.reload.title
    assert_not_nil title
    assert_operator title.length, :<, 50
  end

  test "preserves custom titles" do
    chat = chats(:one)
    chat.generate_title_from_message("New content")

    assert_equal "New Tool for Project Management", chat.title
  end

  test "builds chat context from recent messages" do
    chat = chats(:one)
    12.times do |i|
      chat.messages.create!(role: i.even? ? "user" : "assistant", content: "Message #{i}")
    end

    context = chat.build_context

    assert_equal 10, context.length
    assert context.all? { |m| m[:role].present? && m[:content].present? }
  end
end
