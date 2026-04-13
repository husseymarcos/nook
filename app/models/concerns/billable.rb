module Billable
  extend ActiveSupport::Concern

  included do
    pay_customer
  end

  def premium?
    pay_subscriptions.active.any? || (premium_until.present? && premium_until > Time.current)
  end
end
