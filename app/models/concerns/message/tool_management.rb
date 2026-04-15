module Message::ToolManagement
  extend ActiveSupport::Concern

  def ensure_tools_from_recommendations!(user)
    return unless assistant? && has_recommendations?

    recommendations.each do |rec|
      find_or_create_tool_for_recommendation(rec, user)
    end
  end

  def tools_from_recommendations
    return Tool.none unless assistant?

    names = recommendations.map { |r| r[:name]&.downcase }.compact
    Tool.where("lower(name) IN (?)", names)
  end

  private

    def find_or_create_tool_for_recommendation(recommendation, user)
      return unless recommendation[:name].present?

      tool = Tool.find_by("lower(name) = ?", recommendation[:name].downcase)
      tool ||= create_tool_from_recommendation(recommendation)
      tool
    end

    def create_tool_from_recommendation(recommendation)
      Tool.create(
        name: recommendation[:name],
        description: recommendation[:description],
        platform: recommendation[:platform],
        category: "Other",
        is_default: false
      )
    end
end
