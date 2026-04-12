require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "creates account with email and password" do
    user = User.new(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    assert user.valid?
  end

  test "requires email" do
    user = User.new(password: "password123")
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "requires unique email" do
    user = User.new(
      email: users(:one).email,
      password: "password123",
      password_confirmation: "password123"
    )
    assert_not user.valid?
    assert_includes user.errors[:email], "has already been taken"
  end

  test "normalizes email to lowercase" do
    user = User.create!(
      email: "UPPER@EXAMPLE.COM",
      password: "password123",
      password_confirmation: "password123"
    )
    assert_equal "upper@example.com", user.email
  end

  test "premium users can search unlimited times" do
    user = User.new(premium_until: 1.month.from_now, searches_this_month: 100)
    assert user.can_search?
  end

  test "free users can search when below monthly limit" do
    user = users(:one)
    user.update!(searches_this_month: 5, last_search_reset_at: Time.current)
    assert user.can_search?
  end

  test "free users cannot search when monthly limit reached" do
    user = users(:one)
    user.update!(searches_this_month: 10, last_search_reset_at: Time.current)
    assert_not user.can_search?
  end

  test "resets monthly search counter when new month begins" do
    user = users(:one)
    user.update!(searches_this_month: 10, last_search_reset_at: 2.months.ago)

    assert user.can_search?
    assert_equal 0, user.reload.searches_this_month
  end

  test "tracks search usage" do
    user = users(:one)
    user.update!(searches_this_month: 5)

    assert_difference -> { user.reload.searches_this_month }, 1 do
      user.increment_search_count!
    end
  end

  test "adds tools to personal stack" do
    user = users(:one)
    tool = tools(:streaks)

    assert_difference -> { user.tools.count }, 1 do
      user.add_tool_to_stack(tool)
    end
  end

  test "prevents duplicate tools in stack" do
    user = users(:one)
    tool = tools(:streaks)
    user.add_tool_to_stack(tool)

    assert_not user.add_tool_to_stack(tool)
    assert_equal 1, user.tools.where(id: tool.id).count
  end

  test "enforces maximum of 20 tools per stack" do
    user = users(:three)

    assert_not user.add_tool_to_stack(tools(:streaks))
  end

  test "removes tools from stack" do
    user = users(:one)
    tool = tools(:notion)
    user.add_tool_to_stack(tool)

    assert_difference -> { user.tools.count }, -1 do
      user.remove_tool_from_stack(tool)
    end
  end

  test "lists all tools in stack by name" do
    user = users(:one)
    user.add_tool_to_stack(tools(:notion))
    user.add_tool_to_stack(tools(:figma))

    assert_equal %w[Notion Figma], user.stack_names
  end
end
