class StackToolsController < ApplicationController
  before_action :set_stack

  def create
    tool = if params[:tool_id]
      Tool.find(params[:tool_id])
    else
      Tool.create!(
        name: params[:tool_name],
        description: params[:tool_description] || "Custom tool",
        platform: "Web",
        category: "Other",
        is_default: false
      )
    end

    if @stack.add_tool(tool)
      redirect_to @stack, notice: "#{tool.name} added to stack"
    else
      redirect_to @stack, alert: "Could not add tool (limit reached or already in stack)"
    end
  end

  def destroy
    tool = @stack.tools.find(params[:id])
    @stack.remove_tool(tool)
    redirect_to @stack, notice: "#{tool.name} removed from stack"
  end

  private

    def set_stack
      @stack = Current.user.stacks.find(params[:stack_id])
    end
end
