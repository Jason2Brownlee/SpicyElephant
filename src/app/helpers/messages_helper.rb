module MessagesHelper
  
  def is_current_message_author(message)
    return logged_in? && message.user.id == current_user.id
  end
  
  def author_link(message)
    return "me" if is_current_message_author(message)
    return link_to(message.user.humanized_name, profile_user_path(message.user))
  end
  
end
