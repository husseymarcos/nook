class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_many :user_stacks, dependent: :destroy
  has_many :tools, through: :user_stacks

  validates :email_address, presence: true, uniqueness: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Premium check
  def premium?
    premium_until.present? && premium_until > Time.current
  end

  # Rate limiting
  def can_search?
    return true if premium?

    # Reset counter if new month
    if last_search_reset_at.nil? || last_search_reset_at.month != Time.current.month
      update!(searches_this_month: 0, last_search_reset_at: Time.current)
    end

    searches_this_month < 10
  end

  def increment_search_count!
    increment!(:searches_this_month)
  end

  # Stack methods
  def stack_tools
    tools.order("user_stacks.created_at ASC")
  end

  def add_tool_to_stack(tool)
    return false if tools.count >= 20
    return false if tools.include?(tool)

    tools << tool
  end

  def remove_tool_from_stack(tool)
    tools.delete(tool)
  end

  def stack_names
    stack_tools.pluck(:name)
  end
end
