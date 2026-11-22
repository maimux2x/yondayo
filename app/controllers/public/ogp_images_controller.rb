class Public::OgpImagesController < ApplicationController
  allow_unauthenticated_access

  # SNS が取りに来たときにその場で作る。URL に version が付くので、長めにキャッシュさせても古い画像は残らない。
  def show
    reading   = Reading.includes(:book, :user).find_by!(share_token: params[:reading_share_token])
    ogp_image = Reading::OgpImage.new(reading)

    expires_in 1.week, public: true

    if stale?(etag: ogp_image.version, last_modified: Time.zone.at(ogp_image.version), public: true)
      send_data ogp_image.to_png, type: 'image/png', disposition: 'inline'
    end
  end
end
