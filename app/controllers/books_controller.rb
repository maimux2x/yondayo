class BooksController < ApplicationController
  def create
    isbn      = params.expect(:isbn)
    res       = HTTPX.get('https://api.openbd.jp/v1/get', params: {isbn:})
    payload   = res.json(symbolize_names: true).first
    title     = payload.dig(:summary, :title)
    author    = payload.dig(:summary, :author)
    cover_url = payload.dig(:summary, :cover)

    book = Book.find_or_initialize_by(isbn:)
    book.update!(
      title:,
      author:,

      cover: cover_url.present? ? {
        io:       URI.open(cover_url),
        filename: File.basename(cover_url)
      } : nil
    )

    if reading = Current.user.readings.find_by(book:)
      redirect_to edit_reading_path(reading), status: :see_other
    else
      redirect_to new_reading_path(book_id: book.id), status: :see_other
    end
  end
end
