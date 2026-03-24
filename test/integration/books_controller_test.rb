require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    post session_path, params: {email_address: @user.email_address, password: 'password'}
  end

  test 'index' do
    get books_path

    assert_response :success
    assert_select '.card-title', 2
  end

  test 'show' do
    get book_path(books(:one))

    assert_response :success
  end

  test 'create' do
    assert_difference('Book.count', 1) do
      post books_path, params: {book: {title: 'BOOK3', author: 'Lisa', status: 'unread'}}
    end

    assert_redirected_to book_path(Book.last)
  end

  test 'update' do
    patch book_path(books(:one)), params: {book: {status: 'read'}}

    assert_redirected_to book_path(books(:one))
    assert_equal 'read', books(:one).reload.status
  end

  test 'delete' do
    assert_difference('Book.count', -1) do
      delete book_path(books(:two))
    end

    assert_redirected_to books_path
    follow_redirect!
    assert_select '.card-title', 1
  end

  test 'search' do
    get books_path, params: {search: {
      author: 'Bob',
      status: ['progress']
    }}

    assert_response :success
    assert_select '.card-title', text: 'BOOK2'
    assert_select '.card-title', 1
  end
end
