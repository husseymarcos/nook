require "test_helper"

class UserStackTest < ActiveSupport::TestCase
  test "adds tool to user stack" do
    user_stack = UserStack.new(
      user: users(:one),
      tool: tools(:streaks)
    )
    assert user_stack.valid?
  end

  test "prevents duplicate tools in user stack" do
    duplicate = UserStack.new(user: users(:two), tool: tools(:streaks))

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:user_id], "is already in your stack"
  end

  test "belongs to user" do
    user_stack = UserStack.new(user: users(:one))
    assert_equal users(:one), user_stack.user
  end

  test "belongs to tool" do
    user_stack = UserStack.new(tool: tools(:notion))
    assert_equal tools(:notion), user_stack.tool
  end

  test "enforces maximum stack size of 20 tools" do
    new_stack = UserStack.new(user: users(:three), tool: tools(:streaks))
    assert_not new_stack.valid?
    assert_includes new_stack.errors[:base], "Stack limit reached (max 20 tools)"
  end

  test "allows adding tools when under limit" do
    user = users(:one)
    user.tools << tools(:figma)

    new_stack = UserStack.new(user: user, tool: tools(:streaks))
    assert new_stack.valid?
  end
end
