class BillingController < ApplicationController
  def index
    @user = Current.user
  end

  def checkout
    processor = Current.user.set_payment_processor(:lemon_squeezy)
    checkout_session = processor.checkout(
      variant_id: price_id,
      product_options: {
        redirect_url: billing_success_url
      }
    )

    redirect_to checkout_session.url, allow_other_host: true
  end

  def success
    redirect_to root_path, notice: "Welcome to Nook Premium!"
  end

  def cancel
    redirect_to billing_index_path, alert: "Checkout cancelled. You can upgrade anytime."
  end

  private

  def price_id
    ENV["MONTHLY_PRICE_ID"]
  end
end
