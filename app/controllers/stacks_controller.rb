class StacksController < ApplicationController
  before_action :set_stack, only: [ :show, :destroy ]

  def index
    @stacks = Current.user.stacks.ordered.includes(:tools)
    @stack = @stacks.first || Stack.new
    @default_tools = Tool.default_tools
    @custom_tool = Tool.new
  end

  def show
    @tools = @stack.tools
    @default_tools = Tool.default_tools.where.not(id: @stack.tools.pluck(:id))
  end

  def create
    @stack = Current.user.stacks.build(stack_params)

    if @stack.save
      redirect_to @stack, notice: "Stack '#{@stack.name}' created"
    else
      redirect_to stacks_path, alert: "Could not create stack"
    end
  end

  def destroy
    @stack.destroy
    redirect_to stacks_path, notice: "Stack deleted"
  end

  private

    def set_stack
      @stack = Current.user.stacks.find(params[:id])
    end

    def stack_params
      params.require(:stack).permit(:name)
    end
end
