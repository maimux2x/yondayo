class ReadingLogsController < ApplicationController
  allow_unauthenticated_access only: %i[index show]

  def index
    @pagy, @logs = pagy(ReadingLog.order(created_at: :DESC))
  end

  def show
    @log = ReadingLog.find(params[:id])
  end

  def new
    @log = Current.user.reading_logs.build
    @log.build_book
  end

  def create
    @log = Current.user.reading_logs.build(reading_log_params)

    if @log.save
      redirect_to @log, status: :see_other
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    @log = Current.user.reading_logs.find(params[:id])
  end

  def update
    @log = Current.user.reading_logs.find(params[:id])

    if @log.update(reading_log_params)
      redirect_to @log, status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    Current.user.reading_logs.find(params[:id]).destroy!

    redirect_to reading_logs_path, status: :see_other
  end

  private

  def reading_log_params
    params.expect(reading_log: [
      :status,
      :comment,

      book_attributes: [
        :id,
        :title,
        :author,
        :publisher,
        :published_at
      ]
    ])
  end
end
