class BooksController < ApplicationController
  def index
    if q = params[:q].presence
      payloads = HTTPX.get('https://www.googleapis.com/books/v1/volumes', params: {
        q:,
        maxResults: 3,
        key:        ENV['BOOKS_API_KEY']
      }).json(symbolize_names: true)

      @volumes = payloads[:items].map {|payload|
        volume_info = payload[:volumeInfo]

        {
          id:             payload[:id],
          title:          volume_info[:title],
          author:         volume_info[:authors]&.join(', '),
          publisher:      volume_info[:publisher],
          published_date: volume_info[:publishedDate],
          cover_url:      volume_info.dig(:imageLinks, :thumbnail),
          is_ebook:       payload.dig(:saleInfo, :isEbook)
        }
      }
    end
  end

  def create
    volume_id = params.expect(:volume_id)

    payload = HTTPX.get("https://www.googleapis.com/books/v1/volumes/#{volume_id}", params: {
      key: ENV['BOOKS_API_KEY']
    }).json(symbolize_names: true)

    book        = Book.find_or_initialize_by(google_books_volume_id: volume_id)
    volume_info = payload[:volumeInfo]
    cover       = URI.open(volume_info.dig(:imageLinks, :large) || volume_info.dig(:imageLinks, :thumbnail))

    book.update!(
      title: volume_info[:title],
      author: volume_info[:authors]&.join(', '),

      cover: {
        io:           cover,
        filename:     volume_id,
        content_type: cover.content_type
      }
    )

    if reading = Current.user.readings.find_by(book:)
      redirect_to edit_reading_path(reading), status: :see_other
    else
      redirect_to new_reading_path(book_id: book.id), status: :see_other
    end
  end
end
