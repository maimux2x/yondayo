require 'test_helper'

class Public::ReadingsTest < ActionDispatch::IntegrationTest
  test 'show' do
    get public_reading_path(readings(:alice_alice1).share_token)

    assert_response :ok
    assert_dom '.public-user', 'Aliceの読書記録'
  end

  test 'show (OGP)' do
    reading = readings(:alice_alice1)

    get public_reading_path(reading.share_token)

    ogp_image_url = public_reading_ogp_image_url(reading.share_token, format: :png, v: Reading::OgpImage.new(reading).version)

    assert_dom 'meta[property="og:image"][content=?]', ogp_image_url
    assert_dom 'meta[property="og:image:width"][content="1200"]'
    assert_dom 'meta[property="og:image:height"][content="630"]'
    assert_dom 'meta[property="og:image:alt"][content=?]', '不思議の国のアリス（Aliceの読書記録）'
    assert_dom 'meta[property="og:type"][content="article"]'
    assert_dom 'meta[name="twitter:card"][content="summary_large_image"]'
  end
end
