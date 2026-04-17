module Billable
  extend ActiveSupport::Concern

  included do
    pay_customer
  end

  def premium?
    pay_subscriptions.active.any? || premium_until?
  end

  def premium_until?
    premium_until.present? && premium_until > Time.current
  end

  def start_checkout(redirect_url:)
    set_payment_processor(:lemon_squeezy).checkout(
      variant_id: ENV["MONTHLY_PRICE_ID"],
      product_options: { redirect_url: redirect_url }
    )
  end
end
