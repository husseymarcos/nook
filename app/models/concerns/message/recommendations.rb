module Message::Recommendations
  extend ActiveSupport::Concern

  def recommendations
    if from_assistant?
      Message::RecommendationParser.new(content).parse
    else
      []
    end
  end

  def has_recommendations?
    recommendations.any?
  end

  def content_without_recommendations
    if from_assistant? && has_recommendations?
      content.split(/\d+\.\s*\*\*/).first&.strip
    else
      content
    end
  end
end
