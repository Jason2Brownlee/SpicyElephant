class SitemapController < ActionController::Base
  def sitemap
      @decks = Deck.find(:all, :select => 'decks.id, decks.name, decks.updated_at')
      #@users = User.find(:all, :select => 'id, login, updated_at', :conditions => "activated == 1")
      render :action => 'google_sitemap'
  end
end
