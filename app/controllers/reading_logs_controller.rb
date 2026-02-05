class ReadingLogsController < ApplicationController
  def index
    @logs = ReadingLog.order(:created_at)
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
        :published_at,
        :_destroy
      ]
    ])
  end
end
