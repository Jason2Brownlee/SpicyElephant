module DecksHelper

  def is_current_deck_author(deck)
    return logged_in? && deck.user.id == current_user.id
  end

  def deck_author_link(deck)
    return link_to(deck.user.humanized_name, profile_user_path(deck.user), :class=>'author_deck_link')
  end
  
  def deck_users_link(deck)
    popularity = deck.popularity
    message = "#{pluralize(popularity, 'user')}"
    return message if popularity==0
    return link_to(message, subscribers_deck_path(deck), :class => "users_deck_link")
  end


  def deck_cards(deck)
    return count_cards(deck.cards.count)
  end
  
  def deck_messages(deck)
    count = deck.messages.count
    return "#{pluralize(count, 'message')}"
  end
  
  def count_cards(count)
    message = "#{pluralize(count, 'card')}"
    return message
  end

end
