require "test_helper"

class StackTest < ActiveSupport::TestCase
  test "belongs to user" do
    stack = stacks(:one)
    assert_equal users(:one), stack.user
  end

  test "has many tools through stack_tools" do
    stack = stacks(:one)
    assert_includes stack.tools, tools(:notion)
  end

  test "requires name" do
    stack = Stack.new(user: users(:one))
    assert_not stack.valid?
    assert_includes stack.errors[:name], "can't be blank"
  end

  test "requires unique name per user" do
    stack = Stack.new(user: users(:one), name: "Work")
    assert_not stack.valid?
    assert_includes stack.errors[:name], "has already been taken"
  end

  test "allows same name for different users" do
    stack = Stack.new(user: users(:three), name: "Work")
    assert stack.valid?
  end

  test "adds tool to stack" do
    stack = stacks(:one)
    tool = tools(:streaks)

    assert_difference -> { stack.tools.count }, 1 do
      stack.add_tool(tool)
    end
  end

  test "prevents duplicate tools in stack" do
    stack = stacks(:two)
    tool = tools(:streaks)

    assert_not stack.add_tool(tool)
  end

  test "enforces maximum of 20 tools per stack" do
    stack = stacks(:one)
    19.times { |i| Tool.create!(name: "Tool #{i}", description: "Desc", platform: "Web", category: "Other") }

    # Should be able to add up to 20
    19.times { |i| stack.add_tool(Tool.find_by(name: "Tool #{i}")) }

    # 20th should fail
    extra_tool = Tool.create!(name: "Extra", description: "Desc", platform: "Web", category: "Other")
    assert_not stack.add_tool(extra_tool)
  end

  test "removes tool from stack" do
    stack = stacks(:two)
    tool = tools(:streaks)

    assert_difference -> { stack.tools.count }, -1 do
      stack.remove_tool(tool)
    end
  end

  test "returns tool names" do
    stack = stacks(:one)
    assert_equal [ "Notion" ], stack.tool_names
  end
end
