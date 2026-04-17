class Tool < ApplicationRecord
  PLATFORMS = %w[ iOS Android Web Mac Windows Linux Chrome Extension ].freeze
  CATEGORIES = %w[ Productivity Design Communication Development Entertainment Utilities Other ].freeze

  has_many :stack_tools, dependent: :destroy
  has_many :stacks, through: :stack_tools

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :platform, presence: true, inclusion: { in: PLATFORMS }
  validates :category, inclusion: { in: CATEGORIES }

  scope :default, -> { where(is_default: true) }
  scope :custom, -> { where(is_default: false) }

  def self.create_custom!(name:, description: nil)
    create!(
      name: name,
      description: description.presence || "Custom tool",
      platform: "Web",
      category: "Other",
      is_default: false
    )
  end
end
