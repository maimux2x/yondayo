require 'test_helper'

class BooksTest < ActionDispatch::IntegrationTest
  setup do
    post session_path, params: {email_address: users(:alice).email_address, password: 'password'}
  end

  test 'index' do
    stub_request(:get, 'https://www.googleapis.com/books/v1/volumes').with(
      query: {
        q:          'Title',
        maxResults: 3,
        orderBy:    'relevance',
        key:        'DUMMY'
      }
    ).to_return_json(
      body: {
        items: [
          {
            id: 'volume1',

            volumeInfo: {
              title: 'Title 1',

              imageLinks: {
                thumbnail: 'http://example.com/foo'
              }
            }
          },
          {
            id: 'volume2',

            volumeInfo: {
              title: 'Title 2',

              imageLinks: {
                thumbnail: 'http://example.com/bar'
              }
            }
          }
        ]
      }
    )

    get books_path, params: {
      q: 'Title'
    }

    assert_response :success

    assert_dom 'a', 'Title 1'
    assert_dom 'a', 'Title 2'
  end

  test 'create (new book, new reading)' do
    stub_request(:get, 'https://www.googleapis.com/books/v1/volumes/VOLUME_ID').with(
      query: {
        key: 'DUMMY'
      }
    ).to_return_json(
      body: {
        id: 'VOLUME_ID',

        volumeInfo: {
          title: 'New book',

          authors: [
            'New author'
          ],

          imageLinks: {
            large: 'http://example.com/foo'
          }
        }
      }
    )

    stub_request(:get, 'http://example.com/foo').to_return(
      headers: {'Content-Type' => 'image/png'},
      body:    file_fixture('cover.png').read
    )

    assert_difference 'Book.count', 1 do
      post books_path, params: {
        volume_id: 'VOLUME_ID'
      }

      assert_response :see_other
    end

    book = Book.last

    assert_redirected_to new_reading_path(book_id: book.id)

    assert_equal 'New book',   book.title
    assert_equal 'New author', book.author

    assert book.cover.attached?
  end

  test 'create (existing book, new reading)' do
    Reading.destroy_all

    book = books(:alice1)

    stub_request(:get, "https://www.googleapis.com/books/v1/volumes/#{book.google_books_volume_id}").with(
      query: hash_including({})
    ).to_return_json(
      body: {
        id: book.google_books_volume_id,

        volumeInfo: {
          title: book.title,

          authors: [
            book.author
          ],

          imageLinks: {
            large: 'http://example.com/foo'
          }
        }
      }
    )

    stub_request(:get, 'http://example.com/foo').to_return(
      headers: {'Content-Type' => 'image/png'}
    )

    assert_no_difference 'Book.count' do
      post books_path, params: {
        volume_id: book.google_books_volume_id
      }

      assert_response :see_other
    end

    assert_redirected_to new_reading_path(book_id: book.id)

    assert_equal '不思議の国のアリス', book.title
    assert_equal 'ルイス・キャロル',   book.author
  end

  test 'create (updating book, existing reading)' do
    book = books(:alice1)

    stub_request(:get, "https://www.googleapis.com/books/v1/volumes/#{book.google_books_volume_id}").with(
      query: hash_including({})
    ).to_return_json(
      body: {
        id: book.google_books_volume_id,

        volumeInfo: {
          title: 'Updated title',

          authors: [
            'Updated author'
          ],

          imageLinks: {
            large: 'http://example.com/foo'
          }
        }
      }
    )

    stub_request(:get, 'http://example.com/foo').to_return(
      headers: {'Content-Type' => 'image/png'}
    )

    assert_no_difference 'Book.count' do
      post books_path, params: {
        volume_id: book.google_books_volume_id
      }

      assert_response :see_other
    end

    assert_redirected_to edit_reading_path(readings(:alice_alice1))

    book.reload

    assert_equal 'Updated title',  book.title
    assert_equal 'Updated author', book.author
  end
end
