class Public::ReadingsController < ApplicationController
  allow_unauthenticated_access

  def show
    @reading = Reading.find_by!(share_token: params[:share_token])
  end
end
