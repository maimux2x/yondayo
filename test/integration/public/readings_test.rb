require 'test_helper'

class Public::ReadingsTest < ActionDispatch::IntegrationTest
  test 'show' do
    get public_reading_path(readings(:alice_alice1).share_token)

    assert_response :ok
    assert_dom 'h2', 'Aliceの読書記録'
  end
end
