class Stack < ApplicationRecord
  TOOL_LIMIT = 20

  belongs_to :user
  has_many :stack_tools, dependent: :destroy
  has_many :tools, through: :stack_tools

  validates :name, presence: true, uniqueness: { scope: :user_id }

  scope :chronologically, -> { order(created_at: :asc) }
  scope :preloaded, -> { includes(:tools) }

  def tool_names
    tools.pluck(:name)
  end

  def add_tool(tool)
    if tools.count < TOOL_LIMIT && tools.exclude?(tool)
      tools << tool
      true
    else
      false
    end
  end

  def remove_tool(tool)
    tools.delete(tool)
  end

  def full?
    tools.count >= TOOL_LIMIT
  end
end
