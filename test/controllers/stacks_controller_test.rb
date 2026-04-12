require "test_helper"

class StacksControllerTest < ActionDispatch::IntegrationTest
  test "lists user's stack" do
    get stacks_url
    assert_response :success
  end

  test "adds default tool to stack" do
    tool = tools(:streaks)

    assert_difference "UserStack.count", 1 do
      post stacks_url, params: { tool_id: tool.id }
    end
    assert_redirected_to stacks_path
  end

  test "adds custom tool to stack" do
    assert_difference %w[Tool.count UserStack.count], 1 do
      post stacks_url, params: { tool_name: "My Custom Tool" }
    end
    assert_redirected_to stacks_path
  end

  test "prevents adding duplicate tools" do
    tool = tools(:notion)
    post stacks_url, params: { tool_id: tool.id }

    assert_no_difference "UserStack.count" do
      post stacks_url, params: { tool_id: tool.id }
    end
  end

  test "prevents exceeding stack limit" do
    sign_in_as(users(:three))

    assert_no_difference "UserStack.count" do
      post stacks_url, params: { tool_id: tools(:streaks).id }
    end
  end

  test "removes tool from stack" do
    sign_in_as(users(:two))

    assert_difference "UserStack.count", -1 do
      delete stack_url(tools(:streaks))
    end
    assert_redirected_to stacks_path
  end

  test "requires authentication for index" do
    sign_out
    get stacks_url
    assert_redirected_to new_session_path
  end

  test "requires authentication for create" do
    sign_out
    post stacks_url, params: { tool_id: tools(:notion).id }
    assert_redirected_to new_session_path
  end

  test "requires authentication for destroy" do
    sign_out
    delete stack_url(tools(:notion))
    assert_redirected_to new_session_path
  end
end
