require 'test_helper'

class BooksTest < ActionDispatch::IntegrationTest
  setup do
    post session_path, params: {email_address: users(:alice).email_address, password: 'password'}
  end

  test 'create (new book)' do
    Book.destroy_all

    stub_request(:get, 'https://api.openbd.jp/v1/get').with(
      query: {
        isbn: '1234567890123'
      }
    ).to_return_json(
      body: [
        summary: {
          isbn:   '1234567890123',
          title:  'New book',
          author: 'New author',
          cover:  ''
        }
      ]
    )

    assert_difference 'Book.count', 1 do
      post books_path, params: {isbn: '1234567890123'}

      assert_response :see_other
    end

    book = Book.last

    assert_redirected_to new_reading_path(book_id: book.id)

    assert_equal 'New book',   book.title
    assert_equal 'New author', book.author
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
        onix: {
          DescriptiveDetail: {
            TitleDetail: {
              TitleElement: {
                TitleText: {
                  content: 'Updated title'
                }
              }
            },
            Contributor: [
              PersonName: {
                content: 'Updated author'
              }
            ]
          }
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
