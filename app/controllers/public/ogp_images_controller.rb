class Public::OgpImagesController < ApplicationController
  allow_unauthenticated_access

  # SNS が取りに来たときにその場で作る。URL に version が付くので、長めにキャッシュさせても古い画像は残らない。
  def show
    reading   = Reading.includes(:book, :user).find_by!(share_token: params[:reading_share_token])
    ogp_image = Reading::OgpImage.new(reading)

    # v を変えて Thruster のキャッシュをすり抜け、画像を作らせ続けることができないよう、
    # 今の version の URL でだけ画像を作る。古い v で来た SNS もここで最新の画像に案内される。
    if params[:v] != ogp_image.version.to_s
      redirect_to public_reading_ogp_image_url(reading.share_token, format: :png, v: ogp_image.version)
      return
    end

    expires_in 1.week, public: true

    if stale?(etag: ogp_image.version, last_modified: Time.zone.at(ogp_image.version), public: true)
      send_data ogp_image.to_png, type: 'image/png', disposition: 'inline'
    end
  end
end
