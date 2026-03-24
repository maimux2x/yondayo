module ApplicationHelper
  include Pagy::Method
  def status_badge_class(status)
    case status
    when 'read'     then 'success'
    when 'progress' then 'primary'
    when 'unread'   then 'secondary'
    end
  end
end
