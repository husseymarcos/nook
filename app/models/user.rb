class User < ApplicationRecord
  include Billable
  include RateLimitable

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_many :stacks, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  normalizes :email, with: ->(e) { e.strip.downcase }

  def default_stack
    stacks.first
  end

  def all_tool_names
    stacks.flat_map(&:tool_names).uniq
  end

  def has_tool?(tool)
    stacks.joins(:tools).where(tools: { id: tool.id }).exists?
  end

  def tools
    Tool.joins(stacks: :user).where(stacks: { user_id: id }).distinct
  end
end
