require "test_helper"

class StackToolsControllerTest < ActionDispatch::IntegrationTest
  test "adds existing tool to stack" do
    stack = stacks(:one)
    tool = tools(:streaks)

    assert_difference "StackTool.count", 1 do
      post stack_tools_path(stack), params: { tool_id: tool.id }
    end
    assert_redirected_to stack_path(stack)
  end

  test "creates custom tool and adds to stack" do
    stack = stacks(:one)

    assert_difference [ "Tool.count", "StackTool.count" ], 1 do
      post stack_tools_path(stack), params: { tool_name: "Custom App" }
    end
    assert_redirected_to stack_path(stack)
  end

  test "prevents duplicate tools in stack" do
    sign_in_as(users(:two))
    stack = stacks(:two)
    tool = tools(:streaks)

    assert_no_difference "StackTool.count" do
      post stack_tools_path(stack), params: { tool_id: tool.id }
    end
  end

  test "removes tool from stack" do
    sign_in_as(users(:two))
    stack = stacks(:two)
    tool = tools(:streaks)

    assert_difference "StackTool.count", -1 do
      delete stack_tool_path(stack, tool)
    end
    assert_redirected_to stack_path(stack)
  end

  test "requires authentication" do
    sign_out
    stack = stacks(:one)
    post stack_tools_path(stack), params: { tool_name: "Test" }
    assert_redirected_to new_session_path
  end
end
