require 'test_helper'

class HomesTest < ActionDispatch::IntegrationTest
  setup do
    post session_path, params: {
      email_address: users(:alice).email_address,
      password:      'password'
    }
  end

  test 'show' do
    get root_path

    assert_response :success

    assert_dom 'a', readings(:alice_alice1).book.title
  end
end
