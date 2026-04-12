require "test_helper"
require "ostruct"

class BillingControllerTest < ActionDispatch::IntegrationTest
  test "shows pricing page" do
    get billing_index_url
    assert_response :success
  end

  test "shows premium status for paid users" do
    Current.user.update!(premium_until: 1.month.from_now)

    get billing_index_url
    assert_response :success
  end

  test "redirects checkout to stripe" do
    # Mock Stripe session creation
    mock_session = OpenStruct.new(url: "https://checkout.stripe.com/test")
    Stripe::Checkout::Session.expects(:create).returns(mock_session)

    post checkout_url, params: { plan: "monthly" }
    assert_redirected_to "https://checkout.stripe.com/test"
  end

  test "handles successful payment" do
    user = Current.user

    # Mock Stripe calls
    mock_session = OpenStruct.new(
      subscription: "sub_123",
      customer_email: user.email_address
    )
    mock_subscription = OpenStruct.new(
      current_period_end: 1.month.from_now.to_i
    )

    Stripe::Checkout::Session.expects(:retrieve).returns(mock_session)
    Stripe::Subscription.expects(:retrieve).returns(mock_subscription)

    get billing_success_url, params: { session_id: "cs_test_123" }
    assert_redirected_to root_path
    assert user.reload.premium?
  end

  test "handles cancelled checkout" do
    get billing_cancel_url
    assert_redirected_to billing_index_path
  end

  test "requires authentication for index" do
    sign_out
    get billing_index_url
    assert_redirected_to new_session_path
  end

  test "requires authentication for checkout" do
    sign_out
    post checkout_url
    assert_redirected_to new_session_path
  end
end
