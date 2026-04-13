class Stack < ApplicationRecord
  belongs_to :user
  has_many :stack_tools, dependent: :destroy
  has_many :tools, through: :stack_tools

  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id }

  scope :ordered, -> { order(created_at: :asc) }

  def tool_names
    tools.pluck(:name)
  end

  def add_tool(tool)
    return false if tools.count >= 20
    return false if tools.include?(tool)

    tools << tool
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def remove_tool(tool)
    tools.delete(tool)
  end
end
