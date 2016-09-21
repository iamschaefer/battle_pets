Rails.application.routes.draw do
  resources :arena_services
  resources :pet_contests
  get '/pets', to: 'pets#leader_board'

  # TODO: change these to post only
  get '/pet_contests/:id/accept', to: 'pet_contests#accept'
  get '/pet_contests/:id/complete', to: 'pet_contests#complete'
  get '/pet_contests/:id/cancel', to: 'pet_contests#cancel'
  post '/pet_contests/:id/accept', to: 'pet_contests#accept'
  post '/pet_contests/:id/complete', to: 'pet_contests#complete'
  post '/pet_contests/:id/cancel', to: 'pet_contests#cancel'

  devise_for :users

  get '/pets/types', to: 'pets#types'
  resources :pets

  resources :users do
    resources :pets do
      get :pet_contests, to: 'pet_contests#by_pet'
    end
    get :pet_contests, to: 'pet_contests#by_user'
  end

  # TODO: show contests by pet

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
end
