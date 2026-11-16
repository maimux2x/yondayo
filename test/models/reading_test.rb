require 'test_helper'

class ReadingTest < ActiveSupport::TestCase
  setup do
    @reading = readings(:alice_alice1)
  end

  test '読了にすると読了日に今日が入る' do
    travel_to Time.zone.local(2026, 11, 13, 1, 0) do
      @reading.update!(status: :read)

      assert_equal Date.new(2026, 11, 13), @reading.finished_on
    end
  end

  test '読了日を指定して読了にするとその日付が使われる' do
    @reading.update!(status: :read, finished_on: Date.new(2026, 1, 2))

    assert_equal Date.new(2026, 1, 2), @reading.finished_on
  end

  test '読了から戻すと読了日が消える' do
    @reading.update!(status: :read, finished_on: Date.new(2026, 1, 2))
    @reading.update!(status: :in_progress)

    assert_nil @reading.finished_on
  end

  test '読了以外では読了日を指定しても保存されない' do
    @reading.update!(status: :unread, finished_on: Date.new(2026, 1, 2))

    assert_nil @reading.finished_on
  end
end
