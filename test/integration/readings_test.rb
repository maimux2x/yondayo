require 'test_helper'

class ReadingsTest < ActionDispatch::IntegrationTest
  setup do
    post session_path, params: {email_address: users(:alice).email_address, password: 'password'}
  end

  test 'show' do
    reading = readings(:alice_alice1)

    get reading_path(reading)

    assert_response :ok
    assert_dom 'h1', reading.book.title
  end

  test 'new' do
    get new_reading_path(book_id: books(:alice2).id)

    assert_response :ok
    assert_dom 'input[type="submit"][value="追加する"]'
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

    assert_dom '.status-tag', '未読'
    assert_dom '.prose', 'これから読む'
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

    assert_dom '.status-tag', '読書中'
    assert_dom '.prose', '読み始めた'
  end

  test 'update (read with finished_on)' do
    patch reading_path(readings(:alice_alice1)), params: {
      reading: {
        status:      'read',
        finished_on: '2026-10-01'
      }
    }

    assert_response :see_other

    follow_redirect!

    assert_dom '.status-tag', '読了'
    assert_dom 'time[datetime="2026-10-01"]', '2026年10月01日(木)に読了'
  end

  test 'destroy' do
    delete reading_path(readings(:alice_alice1))

    assert_response :see_other

    follow_redirect!

    assert_not_dom 'a', readings(:alice_alice1).book.title
  end
end
