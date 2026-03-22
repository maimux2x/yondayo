class BooksController < ApplicationController
  def index
    @pagy, @books = pagy(Current.user.books.order(created_at: :DESC))
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
