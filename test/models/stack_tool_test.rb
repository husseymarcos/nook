require "test_helper"

class StackToolTest < ActiveSupport::TestCase
  test "belongs to stack" do
    stack_tool = stack_tools(:one)
    assert_equal stacks(:one), stack_tool.stack
  end

  test "belongs to tool" do
    stack_tool = stack_tools(:one)
    assert_equal tools(:notion), stack_tool.tool
  end

  test "prevents duplicate tools in same stack" do
    duplicate = StackTool.new(stack: stacks(:two), tool: tools(:streaks))
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:tool_id], "is already in this stack"
  end

  test "allows same tool in different stacks" do
    different_stack = stacks(:school)
    same_tool = tools(:streaks)

    stack_tool = StackTool.new(stack: different_stack, tool: same_tool)
    assert stack_tool.valid?
  end
end
