require "test_helper"

class Message::ToolManagementTest < ActiveSupport::TestCase
  setup do
    @unique_tool_name = "TestTool#{SecureRandom.hex(4)}"
  end

  test "assistant message can reference tools that already exist in the system" do
    existing_tool = Tool.create!(
      name: @unique_tool_name,
      description: "A tool",
      platform: "Web",
      category: "Productivity"
    )

    message = Message.new(
      role: "assistant",
      content: "I recommend 1. **#{@unique_tool_name}** - A great tool (Web) - Free",
      chat: chats(:one)
    )

    referenced_tools = message.tools_from_recommendations

    assert_includes referenced_tools, existing_tool
    assert_equal 1, referenced_tools.count
  ensure
    existing_tool&.destroy
  end

  test "tool matching ignores case differences between recommendations and database" do
    lowercase_tool = Tool.create!(
      name: @unique_tool_name.downcase,
      description: "A tool",
      platform: "Web",
      category: "Productivity"
    )

    message = Message.new(
      role: "assistant",
      content: "1. **#{@unique_tool_name.upcase}** - Description (Web) - Free",
      chat: chats(:one)
    )

    referenced_tools = message.tools_from_recommendations

    assert_includes referenced_tools, lowercase_tool
  ensure
    lowercase_tool&.destroy
  end

  test "user message cannot reference tools since they don't make recommendations" do
    user_message = messages(:one)

    assert user_message.from_user?
    assert_empty user_message.tools_from_recommendations
  end

  test "assistant message without recommendations cannot reference any tools" do
    simple_assistant = messages(:two)

    assert simple_assistant.from_assistant?
    assert_empty simple_assistant.tools_from_recommendations
  end

  test "only tools that exist in the system are referenced from recommendations" do
    existing_tool_name = "ExistingTool#{SecureRandom.hex(4)}"
    existing_tool = Tool.create!(
      name: existing_tool_name,
      description: "A real tool",
      platform: "Web",
      category: "Productivity"
    )

    non_existent_tool_name = "FakeTool#{SecureRandom.hex(4)}"

    message = Message.new(
      role: "assistant",
      content: <<~CONTENT,
        1. **#{existing_tool_name}** - A real tool (Web) - Freemium
        2. **#{non_existent_tool_name}** - Does not exist (Web) - Free
      CONTENT
      chat: chats(:one)
    )

    referenced_tools = message.tools_from_recommendations

    assert_includes referenced_tools, existing_tool
    assert_equal 1, referenced_tools.count
  ensure
    existing_tool&.destroy
  end
end
