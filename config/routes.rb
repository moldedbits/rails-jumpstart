Rails.application.routes.draw do

  root to: 'home#index'

  get 'home/index'

  # Errors
  get 'error/forbidden'

  # log in page with form:
  get '/login'     => 'sessions#new'

  # create (post) action for when log in form is submitted:
  post '/login'    => 'sessions#create'

  # delete action to log out:
  delete '/logout' => 'sessions#destroy'


end
