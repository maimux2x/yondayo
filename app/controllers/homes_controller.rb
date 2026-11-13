class HomesController < ApplicationController
  def show
    readings = Current.user.readings

    @stats = readings.group(:status).count
    @pagy, @readings = pagy(readings.includes(:book).order(id: :desc))
  end
end
