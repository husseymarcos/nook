require "test_helper"

class Message::RecommendationParserTest < ActiveSupport::TestCase
  test "parses valid recommendation format" do
    content = "1. **Notion** - All-in-one workspace (Web) - Freemium"
    parser = Message::Recommendations::RecommendationParser.new(content)

    result = parser.parse

    assert_equal 1, result.length
    assert_equal "Notion", result[0][:name]
    assert_equal "All-in-one workspace", result[0][:description]
    assert_equal "Web", result[0][:platform]
    assert_equal "Freemium", result[0][:pricing]
  end

  test "parses multiple recommendations" do
    content = <<~CONTENT
      1. **Notion** - All-in-one workspace (Web) - Freemium
      2. **Figma** - Design tool (Mac) - Free
      3. **Slack** - Team chat (Web) - Paid
    CONTENT

    parser = Message::Recommendations::RecommendationParser.new(content)
    result = parser.parse

    assert_equal 3, result.length
    assert_equal "Slack", result[2][:name]
    assert_equal "Team chat", result[2][:description]
    assert_equal "Web", result[2][:platform]
    assert_equal "Paid", result[2][:pricing]
  end

  test "returns empty array for blank content" do
    parser = Message::Recommendations::RecommendationParser.new("")
    assert_empty parser.parse
  end

  test "returns empty array for nil content" do
    parser = Message::Recommendations::RecommendationParser.new(nil)
    assert_empty parser.parse
  end

  test "returns empty array for incomplete format" do
    content = "1. **Partial** - Description only"
    parser = Message::Recommendations::RecommendationParser.new(content)
    assert_empty parser.parse
  end

  test "trims whitespace from extracted values" do
    content = "1. **  Notion  ** -  Description  (  Web  ) -  Pricing  "
    parser = Message::Recommendations::RecommendationParser.new(content)

    result = parser.parse

    assert_equal "Notion", result[0][:name]
    assert_equal "Description", result[0][:description]
    assert_equal "Web", result[0][:platform]
    assert_equal "Pricing", result[0][:pricing]
  end
end
