class Message < ApplicationRecord
  include Roleable
  include Recommendations
  include Broadcastable
  include ToolManagement

  acts_as_message

  has_many_attached :attachments

  belongs_to :chat
  belongs_to :model, optional: true
  belongs_to :tool_call, optional: true

  validates :content, presence: true, unless: -> { tool? || assistant? }
end
