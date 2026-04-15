module Message::Recommendations
  extend ActiveSupport::Concern

  RECOMMENDATION_PATTERN = /\d+\.\s*\*\*([^*]+)\*\*\s*-\s*([^\(]+)\s*\(([^)]+)\)\s*-\s*(.+)$/

  class RecommendationParser
    def initialize(content)
      @content = content.to_s
    end

    def parse
      return [] if @content.blank?

      @content.scan(RECOMMENDATION_PATTERN).map do |match|
        build_recommendation(match)
      end.compact
    end

    private

      def build_recommendation(match)
        return nil if match.any?(&:nil?)

        {
          name: match[0]&.strip,
          description: match[1]&.strip,
          platform: match[2]&.strip,
          pricing: match[3]&.strip
        }
      end
  end

  def recommendations
    return [] unless assistant?

    RecommendationParser.new(content).parse
  end

  def has_recommendations?
    recommendations.any?
  end

  def content_without_recommendations
    return content unless assistant? && has_recommendations?

    content.split(/\d+\.\s*\*\*/).first&.strip
  end
end
