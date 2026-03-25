class BooksController < ApplicationController
  def create
    isbn    = params.expect(:isbn)
    res     = HTTPX.get('https://api.openbd.jp/v1/get', params: {isbn:})
    payload = res.json(symbolize_names: true).first
    title   = payload.dig(:onix, :DescriptiveDetail, :TitleDetail, :TitleElement, :TitleText, :content)

    author = payload.dig(:onix, :DescriptiveDetail, :Contributor).map {
      it.dig(:PersonName, :content)
    }.join(', ')

    book = Book.find_or_initialize_by(isbn:)
    book.update!(title:, author:)

    if reading = Current.user.readings.find_by(book:)
      redirect_to edit_reading_path(reading)
    else
      redirect_to new_reading_path(book_id: book.id)
    end
  end
end
