class ReadingsController < ApplicationController
  def index
    readings = Current.user.readings.order(id: :desc)

    @pagy, @readings = pagy(readings)
  end

  def show
    @reading = Current.user.readings.find(params[:id])
  end

  def new
    @reading = Current.user.readings.new(book_id: params[:book_id])
  end

  def create
    @reading = Current.user.readings.new(reading_params)

    @reading.save!

    redirect_to reading_path(@reading), status: :see_other
  end

  def edit
    @reading = Current.user.readings.find(params[:id])
  end

  def update
    @reading = Current.user.readings.find(params[:id])

    @reading.update!(reading_params)

    redirect_to reading_path(@reading), status: :see_other
  end

  private

  def reading_params
    params.expect(reading: [
      :book_id,
      :status,
      :comment
    ])
  end
end
