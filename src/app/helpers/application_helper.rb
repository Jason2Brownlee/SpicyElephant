# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # the name of the website used in views
  def site_name
    "Spicy Elephant"
  end
  
  def site_motto
    "the quickest way to put stuff in your brain"
  end

  # the url of the site when displayed in the views
  def site_url
    "http://spicyelephant.com"
  end
  
  # the name of the company used in the views
  def company_name
    "Mayhem"
  end
  
  def company_fullname
    "Mayhem"
  end
  
  # for privacy and such
  def site_physical_location
    "Commonwealth of Australia"
  end
  
  def support_email
    return "support@spicyelephant.com"
  end
  
  # title convention used in the sute
  def title(page_title=nil)
    if !page_title.nil?
	    content_for(:title) { "#{site_name} - #{page_title}" }
	  else
	    content_for(:title) { "#{site_name}" }
	  end
	end
  
  def snippet(thought, wordcount) 
    thought.split[0..(wordcount-1)].join(" ") +(thought.split.size > wordcount ? "..." : "") 
  end 

  def train_on_deck_link(deck, message="study")
    if !deck.cards.empty?
      # always show, and deal in the train controller
      link_to( "<span>#{message}</span>", train_deck_path(:deck => deck), :class => "train_deck_link")
    end
  end
  
    def comments_on_deck_link(deck, message="comments")
      link_to( "<span>#{deck.messages.count} #{message}</span>", deck_messages_path(deck), :class => "comments_deck_link")
    end
  
  # 
  # Only provide the link if the user has the deck in their curriculum
  #
  def remove_from_curriculum_link(deck)
    # validation
    if !logged_in? or deck.nil?
      return
    end

    # deck must be in current users curriculum
    if Curriculum.deck_in_user_curriculum?(current_user, deck)
      link_to("Unsubscribe", curriculum_destroy_path(deck), :class => "del_deck_link", :title => "remove the deck from your study list")
    end
  end
  
  # 
  # Only add the link is the user does not already have the deck in their curriculum 
  #
  def add_to_curriculum_link(deck)
    # validation
    if !logged_in? or deck.nil?
      return
    end
    # only provide link if deck is not in current_user curriculum
    if !Curriculum.deck_in_user_curriculum?(current_user, deck)
      link_to("subscribe", curriculum_add_path(deck), :class => "add_card_link", :title => "add the deck to your study list")
    end
  end
  
  
  # the message displayed in the tab
  def train_tab_msg
    if logged_in?
      num = current_user.cards_remaining
      return "study (#{num})" if (num > 0)
    end
    return 'study'
  end
  
    def train_tab_title
    if logged_in?
      num = current_user.cards_remaining
      return "study (#{num} cards)" if (num > 0)
    end
    return 'study'
  end

end
