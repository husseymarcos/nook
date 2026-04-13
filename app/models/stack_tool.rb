class StackTool < ApplicationRecord
  belongs_to :stack
  belongs_to :tool

  validates :tool_id, uniqueness: { scope: :stack_id, message: "is already in this stack" }
end
