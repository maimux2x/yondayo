require 'test_helper'

class ProfilesTest < ActionDispatch::IntegrationTest
  setup do
    post session_path, params: {
      email_address: users(:alice).email_address,
      password:      'password'
    }
  end

  test 'edit' do
    get edit_profile_path(user_id: users(:alice).id)

    assert_response :ok
    assert_dom 'input[type="submit"][value="更新"]'
  end

  test 'update' do
    patch profile_path(user_id: users(:alice).id), params: {
      user: {
        avatar: fixture_file_upload('avatar.png', 'img/png')
      }
    }

    assert_redirected_to edit_profile_path
    assert_equal '更新しました。', flash[:notice]
  end
end
