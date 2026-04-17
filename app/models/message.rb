class Message < ApplicationRecord
  include Roleable, Recommendations, Broadcastable, ToolManagement

  acts_as_message

  has_many_attached :attachments

  belongs_to :chat
  belongs_to :model, optional: true
  belongs_to :tool_call, optional: true

  scope :chronologically, -> { order(created_at: :asc) }

  validates :content, presence: true, unless: -> { tool? || assistant? }
end
