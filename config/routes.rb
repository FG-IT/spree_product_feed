Spree::Core::Engine.add_routes do
  get '/feeds/facebook/full', to: 'facebook_feeds#full', format: 'rss'
  get '/feeds/facebook/daily', to: 'facebook_feeds#daily', format: 'rss'
  get '/feeds/facebook/hourly', to: 'facebook_feeds#hourly', format: 'rss'
end
