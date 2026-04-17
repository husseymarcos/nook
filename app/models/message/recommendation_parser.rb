class Message::RecommendationParser
  PATTERN = /\d+\.\s*\*\*([^*]+)\*\*\s*-\s*([^\(]+)\s*\(([^)]+)\)\s*-\s*(.+)$/

  def initialize(content)
    @content = content.to_s
  end

  def parse
    if @content.present?
      @content.scan(PATTERN).map { |match| build_recommendation(match) }.compact
    else
      []
    end
  end

  private
    def build_recommendation(match)
      return if match.any?(&:nil?)

      {
        name: match[0]&.strip,
        description: match[1]&.strip,
        platform: match[2]&.strip,
        pricing: match[3]&.strip
      }
    end
end
