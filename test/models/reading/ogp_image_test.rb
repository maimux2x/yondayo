require 'test_helper'

class Reading::OgpImageTest < ActiveSupport::TestCase
  setup do
    @reading = readings(:alice_alice1)
  end

  test 'Pango のマークアップに使う文字や長いタイトル、著者なしでも画像を作れる' do
    @reading.book.assign_attributes(title: '<b>&</b>' * 40, author: nil)

    image = Vips::Image.new_from_buffer(Reading::OgpImage.new(@reading).to_png, '')

    assert_equal [1200, 630], [image.width, image.height]
  end

  test '本の情報が変わると version が変わる' do
    travel_to 1.day.from_now do
      assert_changes -> { Reading::OgpImage.new(@reading).version } do
        @reading.book.update!(title: '新しいタイトル')
      end
    end
  end
end
