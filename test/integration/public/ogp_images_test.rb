require 'test_helper'

class Public::OgpImagesTest < ActionDispatch::IntegrationTest
  setup do
    @reading = readings(:alice_alice1)
  end

  test 'show' do
    get public_reading_ogp_image_path(@reading.share_token, format: :png)

    assert_response :ok
    assert_equal 'image/png', response.media_type
    assert_includes response.headers['Cache-Control'], 'public'

    image = Vips::Image.new_from_buffer(response.body, '')

    assert_equal [1200, 630], [image.width, image.height]
  end

  test 'show (not modified)' do
    get public_reading_ogp_image_path(@reading.share_token, format: :png)
    get public_reading_ogp_image_path(@reading.share_token, format: :png), headers: {'If-None-Match' => response.headers['ETag']}

    assert_response :not_modified
  end

  test 'show (unknown share token)' do
    get public_reading_ogp_image_path('unknown', format: :png)

    assert_response :not_found
  end
end
