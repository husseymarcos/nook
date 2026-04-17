module Message::Roleable
  extend ActiveSupport::Concern

  ROLES = %w[ user assistant system tool ].freeze

  included do
    validates :role, inclusion: { in: ROLES }
  end

  ROLES.each do |name|
    define_method("#{name}?") { role == name }
    alias_method "from_#{name}?", "#{name}?"
  end
end
