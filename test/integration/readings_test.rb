require 'test_helper'

class ReadingsTest < ActionDispatch::IntegrationTest
  setup do
    post session_path, params: {email_address: users(:alice).email_address, password: 'password'}
  end

  test 'index' do
    get readings_path

    assert_response :success
    assert_dom 'a', readings(:alice_alice1).book.title
  end

  test 'show' do
    reading = readings(:alice_alice1)

    get reading_path(reading)

    assert_response :success
    assert_dom 'h2', reading.book.title
  end

  test 'new (without book_id)' do
    get new_reading_path

    assert_response :success
    assert_dom 'input[type="submit"][value="検索"]'
  end

  test 'new (with book_id)' do
    get new_reading_path(book_id: books(:alice2).id)

    assert_response :success
    assert_dom 'input[type="submit"][value="追加"]'
  end

  test 'create' do
    post readings_path, params: {
      reading: {
        book_id: books(:alice2).id,
        status:  'unread',
        comment: 'これから読む'
      }
    }

    assert_response :see_other

    follow_redirect!

    assert_dom 'dd', '未読'
    assert_dom 'dd', 'これから読む'
  end

  test 'edit' do
    get edit_reading_path(readings(:alice_alice1))

    assert_response :success
    assert_dom 'input[type="submit"][value="更新"]'
  end

  test 'update' do
    patch reading_path(readings(:alice_alice1)), params: {
      reading: {
        status:  'in_progress',
        comment: '読み始めた'
      }
    }

    assert_response :see_other

    follow_redirect!

    assert_dom 'dd', '読んでいる'
    assert_dom 'dd', '読み始めた'
  end

  test 'destroy' do
    delete reading_path(readings(:alice_alice1))

    assert_response :see_other

    follow_redirect!

    assert_not_dom 'a', readings(:alice_alice1).book.title
  end
end
