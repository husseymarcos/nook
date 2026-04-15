require "test_helper"

class Message::RecommendationsTest < ActiveSupport::TestCase
  test "user messages never contain tool recommendations" do
    user_message = messages(:one)

    assert user_message.from_user?
    assert_empty user_message.recommendations
  end

  test "system messages never contain tool recommendations" do
    system_message = Message.new(role: "system", content: "1. **Tool** - Desc (Web) - Free")

    assert system_message.from_system?
    assert_empty system_message.recommendations
  end

  test "assistant message with formatted recommendations lists all recommended tools" do
    assistant_response = messages(:three)

    assert assistant_response.from_assistant?
    assert assistant_response.has_recommendations?
    assert_equal 3, assistant_response.recommendations.count

    first_rec = assistant_response.recommendations.first
    assert_equal "Notion", first_rec[:name]
    assert_equal "All-in-one workspace", first_rec[:description]
    assert_equal "Web", first_rec[:platform]
    assert_equal "Freemium", first_rec[:pricing]
  end

  test "assistant message without formatted recommendations has no recommendations" do
    simple_response = messages(:two)

    assert simple_response.from_assistant?
    assert_not simple_response.has_recommendations?
    assert_empty simple_response.recommendations
  end

  test "incomplete recommendation format is ignored and not extracted" do
    partial_response = messages(:four)

    assert partial_response.from_assistant?
    assert_not partial_response.has_recommendations?
    assert_empty partial_response.recommendations
  end

  test "assistant response can be split into narrative and tool recommendations" do
    response_with_recommendations = messages(:three)

    narrative = response_with_recommendations.content_without_recommendations
    recommendations = response_with_recommendations.recommendations

    assert_equal "Here are my recommendations:", narrative
    assert_equal 3, recommendations.count
  end

  test "assistant response without recommendations uses full content as narrative" do
    simple_response = messages(:two)

    narrative = simple_response.content_without_recommendations

    assert_equal simple_response.content, narrative
    assert_empty simple_response.recommendations
  end
end
