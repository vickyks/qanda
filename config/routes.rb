Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }

  root 'questions#index'

  resources :questions do
    resources :answers
  end
end
