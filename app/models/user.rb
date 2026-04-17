class User < ApplicationRecord
  include Billable, RateLimitable

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_many :stacks, dependent: :destroy
  has_many :chats, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  normalizes :email, with: ->(e) { e.strip.downcase }

  def default_stack
    stacks.first
  end

  def tool_names
    stacks.flat_map(&:tool_names).uniq
  end

  def owns?(tool)
    tools.exists?(id: tool.id)
  end

  def tools
    Tool.joins(:stacks).where(stacks: { user_id: id }).distinct
  end
end
