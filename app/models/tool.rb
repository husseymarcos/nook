class Tool < ApplicationRecord
  has_many :stack_tools, dependent: :destroy
  has_many :stacks, through: :stack_tools

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :platform, presence: true

  # Scopes
  scope :default_tools, -> { where(is_default: true) }
  scope :custom_tools, -> { where(is_default: false) }

  # Platforms
  PLATFORMS = %w[iOS Android Web Mac Windows Linux Chrome Extension].freeze

  # Categories
  CATEGORIES = %w[Productivity Design Communication Development Entertainment Utilities Other].freeze

  validates :platform, inclusion: { in: PLATFORMS }
  validates :category, inclusion: { in: CATEGORIES }
end
