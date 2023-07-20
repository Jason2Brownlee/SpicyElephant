ActionController::Routing::Routes.draw do |map|

# dump
  # map.resources :cardies
  # map.resources :super_cards
  # See how all your routes lay out with "rake routes"
  #map.resources :pages
  # map.deck_users 'decks/:id/users', :controller => 'decks', :action => 'deck_users'
  # map.deck_recommend 'decks/:deck/recommend', :controller => 'decks', :action => 'recommend'
  # map.deck_copy 'decks/:deck/copy', :controller => 'decks', :action => 'copy'
  # examples
  # map.examples 'examples', :controller => 'examples'
  # map.change_time_zone 'users/:id/timezone', :controller => 'users', :action => 'change_time_zone'
  # map.change_email_notification 'users/:id/emailNotification', :controller => 'users', :action => 'change_email_notification'
  # map.cards_upload 'decks/:deck_id/cards/upload', :controller => 'cards', :action => 'upload_csv'
  # map.cards_export 'decks/:deck_id/cards/export', :controller => 'cards', :action => 'export_csv'
  # map.resources :bb_cards
# map.resources :messages
  # map.inplace_edit 'inplace_edit', :controller => 'inplace_edit', :action => 'edit_card'
  
  
  
  map.load_chart '/history/load_chart', :controller => 'history', :action => 'load_chart'

  # craig's user management death
  # authentication management
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.activate '/activate/:id', :controller => 'accounts', :action => 'show'
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.reset_password '/reset_password/:id', :controller => 'passwords', :action => 'edit'
  map.change_password '/change_password', :controller => 'accounts', :action => 'edit'
  map.open_id_complete 'session', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  
  map.search '/search', :controller => 'search', :action => 'index'
  
  map.checkout 'payments/checkout', :controller => 'payments', :action => 'checkout', :requirements => { :method => :post }
  map.upgrade 'upgrade', :controller => 'payments', :action => 'upgrade'
  

  
  map.resources :subscriptions
 
  map.resources :users, :has_many => :decks, :member => { :enable => :put, :current_user => :get, :emailNotification=>:get} do |users|
    users.resource :account
    users.resources :roles
  end

  map.resource :session
  map.resource :password


  map.cards_upload 'decks/:deck_id/cards/upload', :controller => 'cards', :action => 'upload_csv'  
  map.recommend 'decks/:id/recommend', :controller => 'decks', :action => 'recommend'
  map.resources :decks, :member => {:subscribers=>:get, :recommend=>:post, :copy=>:get} do |deck|
    deck.resources :cards, :collection => {:upload_csv=>:post, :export_csv=>:get}
    deck.resources :messages
  end  

  
  map.user_activities 'activities/:id', :controller => 'activities'
  
  # curriculum things
  map.curriculum_add 'curriculums/:deck/add', :controller => 'curriculums', :action => 'create'
  map.curriculum_destroy 'curriculums/:deck/destroy', :controller => 'curriculums', :action => 'destroy'

  # user profile
  map.profile 'profile', :controller => 'profile'
  map.profile_user 'profile/:user', :controller => 'profile'
  map.stats 'stats', :controller => 'profile', :action => 'stats'
  map.stats_user 'stats/:user', :controller => 'profile', :action => 'stats'
  
  # training controller of death (mode/deck/card/result)
  map.with_options :controller => 'train' do |t|
    t.train2                'train2', :action => 'train2'
    t.train                 'train', :action => 'train'
    t.train_deck            'train/:deck', :action => 'train'
    t.train_ruminate_start  'train_deck/:study_mode/:deck', :action => 'ruminate_start'
    t.train_ruminate_all_start  'train_all/:study_mode.:format', :action => 'ruminate_start'
    t.ajax_train_ruminate   'train/:study_session/ruminate.js', :action => 'ruminate', :format => 'js'
    t.train_ruminate        'train/:study_session/ruminate.:format', :action => 'ruminate'
    t.ajax_train_result     'train/:study_session/result/:card/:result.js', :action => 'result', :format => 'js', :requirements => {:method => :put}
    t.train_result          'train/:study_session/result/:card/:result.:format', :action => 'result' 
    t.train_finish          'train/:study_session/finish', :action => 'finish'
  end

  # home things, generally static pages
  map.with_options :controller => 'home' do |home|
    home.home 'home', :action => 'index'
    home.terms 'terms', :action => 'terms'
    home.privacy 'privacy', :action => 'privacy'
    home.feedback 'feedback', :action => 'feedback'
    home.help 'help', :action => 'help'
  end
  
  

  
  
  
  # sitemap route
  map.connect "sitemap.xml", :controller => "sitemap", :action => "sitemap"

   # TinyMCE gzip compressor
  TinyMceGzip::Routes.add_routes
  
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
 
end
