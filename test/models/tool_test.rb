require "test_helper"

class ToolTest < ActiveSupport::TestCase
  test "creates tool with required fields" do
    tool = Tool.new(
      name: "Test Tool",
      description: "A test tool",
      platform: "Web",
      category: "Productivity"
    )
    assert tool.valid?
  end

  test "requires name" do
    tool = Tool.new(description: "Test", platform: "Web")
    assert_not tool.valid?
    assert_includes tool.errors[:name], "can't be blank"
  end

  test "requires description" do
    tool = Tool.new(name: "Test", platform: "Web")
    assert_not tool.valid?
    assert_includes tool.errors[:description], "can't be blank"
  end

  test "requires platform" do
    tool = Tool.new(name: "Test", description: "Test")
    assert_not tool.valid?
    assert_includes tool.errors[:platform], "can't be blank"
  end

  test "requires unique name" do
    tool = Tool.new(
      name: tools(:notion).name,
      description: "Test",
      platform: "Web",
      category: "Other"
    )
    assert_not tool.valid?
    assert_includes tool.errors[:name], "has already been taken"
  end

  test "only accepts valid platforms" do
    tool = Tool.new(
      name: "Test",
      description: "Test",
      platform: "InvalidPlatform",
      category: "Other"
    )
    assert_not tool.valid?
    assert_includes tool.errors[:platform], "is not included in the list"
  end

  test "only accepts valid categories" do
    tool = Tool.new(
      name: "Test",
      description: "Test",
      platform: "Web",
      category: "InvalidCategory"
    )
    assert_not tool.valid?
    assert_includes tool.errors[:category], "is not included in the list"
  end

  test "scopes default tools" do
    defaults = Tool.default
    assert defaults.all?(&:is_default)
    assert_includes defaults, tools(:notion)
    assert_not_includes defaults, tools(:custom)
  end

  test "scopes custom tools" do
    customs = Tool.custom
    assert customs.none?(&:is_default)
    assert_includes customs, tools(:custom)
  end
end
