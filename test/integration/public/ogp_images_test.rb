require 'test_helper'

class Public::OgpImagesTest < ActionDispatch::IntegrationTest
  setup do
    @reading = readings(:alice_alice1)
    @path    = public_reading_ogp_image_path(@reading.share_token, format: :png, v: Reading::OgpImage.new(@reading).version)
  end

  test 'show' do
    get @path

    assert_response :ok
    assert_equal 'image/png', response.media_type
    assert_includes response.headers['Cache-Control'], 'public'

    image = Vips::Image.new_from_buffer(response.body, '')

    assert_equal [1200, 630], [image.width, image.height]
  end

  test 'show (not modified)' do
    get @path
    get @path, headers: {'If-None-Match' => response.headers['ETag']}

    assert_response :not_modified
  end

  test 'show (outdated or missing version)' do
    get public_reading_ogp_image_path(@reading.share_token, format: :png, v: 1)

    assert_redirected_to public_reading_ogp_image_url(@reading.share_token, format: :png, v: Reading::OgpImage.new(@reading).version)
    assert_empty response.body

    get public_reading_ogp_image_path(@reading.share_token, format: :png)

    assert_response :redirect
  end

  test 'show (unknown share token)' do
    get public_reading_ogp_image_path('unknown', format: :png)

    assert_response :not_found
  end
end
