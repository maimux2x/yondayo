module ApplicationHelper
  include Pagy::Method

  def status_tag(reading)
    tag.span(reading.status_i18n, class: ['status-tag', "status-tag--#{reading.status}"])
  end

  def finished_on_tag(reading, suffix: nil)
    return unless reading.read? && reading.finished_on

    tag.time("#{l(reading.finished_on, format: :long)}#{suffix}", class: 'meta-date', datetime: reading.finished_on.iso8601)
  end

  # アバター画像が無いときは名前の1文字目を表示する
  def avatar_tag(user, class_name:)
    if user.avatar.attached?
      image_tag user.avatar.variant(:profile), class: class_name, alt: ''
    else
      tag.span(user.name.first, class: class_name, aria: {hidden: true})
    end
  end
end
