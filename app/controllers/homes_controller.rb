class HomesController < ApplicationController
  def show
    readings = Current.user.readings.order(id: :desc)

    @pagy, @readings = pagy(readings)
  end
end
