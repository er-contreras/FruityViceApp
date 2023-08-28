require "test_helper"

class FruitsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get fruits_index_url
    assert_response :success
  end

  test "should get export_csv" do
    get fruits_export_csv_url
    assert_response :success
  end
end
