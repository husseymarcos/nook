require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "shows signup form" do
    get new_user_url
    assert_response :success
  end

  test "creates account with valid credentials" do
    assert_difference "User.count", 1 do
      post users_url, params: {
        user: {
          email: "new@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
    assert_redirected_to root_path
  end

  test "rejects signup with mismatched passwords" do
    assert_no_difference "User.count" do
      post users_url, params: {
        user: {
          email: "new@example.com",
          password: "password123",
          password_confirmation: "different"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "rejects signup with duplicate email" do
    assert_no_difference "User.count" do
      post users_url, params: {
        user: {
          email: users(:one).email,
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
    assert_response :unprocessable_entity
  end
end
