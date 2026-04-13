class StacksController < ApplicationController
  before_action :set_tool, only: [ :create, :destroy ]

  def index
    @stack_tools = Current.user.stack_tools
    @default_tools = Tool.default_tools.where.not(id: Current.user.tools.pluck(:id))
    @custom_tool = Tool.new
  end

  def create
    tool = if params[:tool_id]
      Tool.find(params[:tool_id])
    else
      # Create custom tool
      Tool.create!(
        name: params[:tool_name],
        description: params[:tool_description] || "Custom tool",
        platform: "Web",
        category: "Other",
        is_default: false
      )
    end

    if Current.user.add_tool_to_stack(tool)
      redirect_to stacks_path, notice: "#{tool.name} added to your stack"
    else
      redirect_to stacks_path, alert: "Could not add tool to stack (limit reached or already added)"
    end
  end

  def destroy
    tool = Current.user.tools.find(params[:id])
    Current.user.remove_tool_from_stack(tool)
    redirect_to stacks_path, notice: "#{tool.name} removed from your stack"
  end

  private

  def set_tool
    # Tool is found via params in each action
  end
end
