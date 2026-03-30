require 'test_helper'

class BooksTest < ActionDispatch::IntegrationTest
  setup do
    post session_path, params: {email_address: users(:alice).email_address, password: 'password'}
  end

  test 'index' do
    stub_request(:get, 'https://www.googleapis.com/books/v1/volumes').with(
      query: hash_including(
        q: 'Title'
      )
    ).to_return_json(
      body: {
        items: [
          {
            id: 'volume1',

            volumeInfo: {
              title: 'Title 1'
            }
          },
          {
            id: 'volume2',

            volumeInfo: {
              title: 'Title 2'
            }
          }
        ]
      }
    )

    get books_path, params: {
      q: 'Title'
    }

    assert_response :success
  end

  test 'create (existing book, new reading)' do
    Reading.destroy_all

    book = books(:alice1)

    stub_request(:get, 'https://api.openbd.jp/v1/get').with(
      query: {
        isbn: book.isbn
      }
    ).to_return_json(
      body: [
        summary: {
          isbn:   book.isbn,
          title:  'BOOK',
          author: 'Charlie',
          cover:  ''
        }
      ]
    )

    assert_no_difference 'Book.count' do
      post books_path, params: {isbn: book.isbn}

      assert_response :see_other
    end

    book.reload

    assert_redirected_to new_reading_path(book_id: book.id)

    assert_equal 'BOOK',    book.title
    assert_equal 'Charlie', book.author
  end

  test 'create (existing book, existing reading)' do
    book = books(:alice1)

    stub_request(:get, 'https://api.openbd.jp/v1/get').with(
      query: {
        isbn: book.isbn
      }
    ).to_return_json(
      body: [
        summary: {
          izsbn:   book.isbn,
          title:  'Updated title',
          author: 'Updated author',
          cover:  ''
        }
      ]
    )

    assert_no_difference 'Book.count' do
      post books_path, params: {isbn: book.isbn}
    end

    assert_redirected_to edit_reading_path(readings(:alice_alice1))

    book.reload

    assert_equal 'Updated title',  book.title
    assert_equal 'Updated author', book.author
  end
end
