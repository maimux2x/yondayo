class BooksController < ApplicationController
  def search
    res = HTTPX.get('https://www.googleapis.com/books/v1/volumes', params: {
      q:   params.expect(:q),
      key: ENV['BOOKS_API_KEY']
    })

    payloads = res.json(symbolize_names: true)

    @books = payloads[:items][0..2].map {|payload|
      {
        id:     payload[:id],
        title:  payload.dig(:volumeInfo, :title),
        author: payload.dig(:volumeInfo, :authors).join(', ')
      }
    }

    render 'readings/new'
  end
end
