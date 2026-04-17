module Message::ToolManagement
  extend ActiveSupport::Concern

  def ensure_tools_from_recommendations!(user)
    if from_assistant? && has_recommendations?
      recommendations.each { |recommendation| find_or_create_tool_for(recommendation) }
    end
  end

  def tools_from_recommendations
    if from_assistant?
      Tool.where("lower(name) IN (?)", recommendation_names)
    else
      Tool.none
    end
  end

  private
    def recommendation_names
      recommendations.map { |r| r[:name]&.downcase }.compact
    end

    def find_or_create_tool_for(recommendation)
      if recommendation[:name].present?
        Tool.find_by("lower(name) = ?", recommendation[:name].downcase) ||
          Tool.create(
            name: recommendation[:name],
            description: recommendation[:description],
            platform: recommendation[:platform],
            category: "Other",
            is_default: false
          )
      end
    end
end
