module ApplicationHelper
  def body_class
    return format('%s-page', params[:id].tr('_', '-')) if controller_path == 'pages' && action_name == 'show'
    format('%s-%s-page', controller_path.tr('/_', '-'), action_name)
  end

  def display_datetime(datetime, format)
    datetime.nil? ? '' : I18n.localize(datetime, format: format)
  end

  def display_avatar_url(user)
    user.avatar_url.presence || 'default-user.png'
  end
end
