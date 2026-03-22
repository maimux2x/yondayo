class BooksController < ApplicationController
  class Search
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Attributes::Normalization
    include ActiveRecord::Sanitization::ClassMethods

    normalizes :title, :author, :created_at_from, :created_at_to, with: -> { it.presence }
    normalizes :status, with: -> { it.reject(&:blank?).presence }

    def result
      books = Current.user.books.all

      books = books.where('title LIKE ?', "%#{sanitize_sql_like(title)}%") if title
      books = books.where('author LIKE ?', "%#{sanitize_sql_like(author)}%") if author

      books = books.where(status:) if status

      books = books.where('created_at >= ?', created_at_from) if created_at_from
      books = books.where('created_at <= ?', created_at_to.to_date.end_of_day) if created_at_to

      books
    end
  end

  def index
    @search = Search.new(search_params)

    @pagy, @books = pagy(@search.result.order(created_at: :DESC))
  end

  def show
    @book = Current.user.books.find(params[:id])
  end

  def new
    @book = Current.user.books.new
  end

  def create
    @book = Current.user.books.new(book_params)

    if @book.save
      redirect_to @book, status: :see_other
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    @book = Current.user.books.find(params[:id])
  end

  def update
    @book = Current.user.books.find(params[:id])

    if @book.update(book_params)
      redirect_to @book, status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    Current.user.books.find(params[:id]).destroy!

    redirect_to books_path, status: :see_other
  end

  private

  def search_params
    return {} unless params[:search]

    params.expect(search: [
      :title,
      :author,
      :created_at_from,
      :created_at_to,

      {
        status: []
      }
    ])
  end

  def book_params
    params.expect(book: [
      :id,
      :title,
      :author,
      :status,
      :comment
    ])
  end
end
