class BillingController < ApplicationController
  before_action :require_authentication

  def index
    @user = Current.user
  end

  def checkout
    session = Stripe::Checkout::Session.create(
      customer_email: Current.user.email_address,
      line_items: [ {
        price: stripe_price_id,
        quantity: 1
      } ],
      mode: "subscription",
      success_url: billing_success_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: billing_cancel_url
    )

    redirect_to session.url, allow_other_host: true
  end

  def success
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    subscription = Stripe::Subscription.retrieve(session.subscription)

    # Update user's premium status
    Current.user.update!(
      premium_until: Time.at(subscription.current_period_end)
    )

    redirect_to root_path, notice: "Welcome to Nook Premium!"
  end

  def cancel
    redirect_to billing_index_path, alert: "Checkout cancelled. You can upgrade anytime."
  end

  private

  def stripe_price_id
    # You would set these in your Stripe dashboard
    case params[:plan]
    when "annual"
      ENV["STRIPE_ANNUAL_PRICE_ID"]
    else
      ENV["STRIPE_MONTHLY_PRICE_ID"]
    end
  end
end
