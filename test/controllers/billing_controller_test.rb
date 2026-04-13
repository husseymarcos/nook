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

  test "redirects checkout to payment processor" do
    mock_customer_list = OpenStruct.new(data: [])
    mock_customer = OpenStruct.new(id: "cust_123")
    mock_checkout = OpenStruct.new(url: "https://checkout.lemonsqueezy.com/test")

    ::LemonSqueezy::Customer.expects(:list).returns(mock_customer_list)
    ::LemonSqueezy::Customer.expects(:create).returns(mock_customer)
    ::LemonSqueezy::Checkout.expects(:create).returns(mock_checkout)

    post checkout_url, params: { plan: "monthly" }
    assert_redirected_to "https://checkout.lemonsqueezy.com/test"
  end

  test "handles successful payment" do
    get billing_success_url
    assert_redirected_to root_path
    assert_equal "Welcome to Nook Premium!", flash[:notice]
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
