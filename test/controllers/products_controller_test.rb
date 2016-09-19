require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  test "should get import" do
    get :import
    assert_response :success
  end

  test "should get upload" do
    get :upload
    assert_response :success
  end

end
