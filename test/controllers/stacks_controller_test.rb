require "test_helper"

class StacksControllerTest < ActionDispatch::IntegrationTest
  test "lists user's stacks" do
    get stacks_url
    assert_response :success
  end

  test "creates new stack" do
    assert_difference "Stack.count", 1 do
      post stacks_url, params: { stack: { name: "Work Tools" } }
    end
    assert_redirected_to stack_path(Stack.last)
  end

  test "shows stack" do
    stack = stacks(:one)
    get stack_url(stack)
    assert_response :success
  end

  test "deletes stack" do
    stack = stacks(:one)
    assert_difference "Stack.count", -1 do
      delete stack_url(stack)
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
    post stacks_url, params: { stack: { name: "Test" } }
    assert_redirected_to new_session_path
  end
end
