require 'avatar/view/action_view_support'
module UsersHelper
  include Avatar::View::ActionViewSupport

  def is_current_user_account?(a_user)
    return false if !logged_in?
    return false if current_user.id != a_user.id
    return true
  end
  
  def user_link(user)
    return "you" if is_current_user_account?(user)
    return link_to(user.humanized_name, profile_user_path(user))
  end
  
  
  
end