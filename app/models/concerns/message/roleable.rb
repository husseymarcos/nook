module Message::Roleable
  extend ActiveSupport::Concern

  VALID_ROLES = %w[user assistant system tool].freeze

  included do
    validates :role, inclusion: { in: VALID_ROLES }
  end

  def user?
    role == "user"
  end
  alias from_user? user?

  def assistant?
    role == "assistant"
  end
  alias from_assistant? assistant?

  def system?
    role == "system"
  end
  alias from_system? system?

  def tool?
    role == "tool"
  end
  alias from_tool? tool?
end
