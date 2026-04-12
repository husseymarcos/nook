class UserStack < ApplicationRecord
  belongs_to :user
  belongs_to :tool

  validates :user_id, uniqueness: { scope: :tool_id, message: "is already in your stack" }
  validate :stack_limit_not_exceeded, on: :create

  private

  def stack_limit_not_exceeded
    if user.tools.count >= 20
      errors.add(:base, "Stack limit reached (max 20 tools)")
    end
  end
end
