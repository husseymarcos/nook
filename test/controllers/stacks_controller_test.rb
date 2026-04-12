require "test_helper"

class StacksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get stacks_index_url
    assert_response :success
  end

  test "should get show" do
    get stacks_show_url
    assert_response :success
  end

  test "should get create" do
    get stacks_create_url
    assert_response :success
  end

  test "should get destroy" do
    get stacks_destroy_url
    assert_response :success
  end
end
