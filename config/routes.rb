Tradr::Application.routes.draw do
  root :to => 'home#index'
  resources :users, :only => [:index, :new, :create]
  resources :stocks, :only => [:index, :new, :create] do
    collection do
      get '/chartdata/:symbol', :action => 'chartdata'
    end
  end
  get '/login' => 'session#new'
  post '/login' => 'session#create'
  delete '/login' => 'session#destroy'
end
