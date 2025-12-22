require "sidekiq/web"

Rails.application.routes.draw do
  # Sidekiq Web UI (authenticated users only in production)
  if Rails.env.development?
    mount Sidekiq::Web => "/sidekiq"
  else
    authenticate :user do
      mount Sidekiq::Web => "/sidekiq"
    end
  end

  # Locale switching
  get "locale/:locale", to: "locale#update", as: :locale

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }

  # Email preview in development
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Authenticated routes
  authenticated :user do
    root "dashboard#index", as: :authenticated_root
  end

  # Public root
  root "home#index"

  # Dashboard
  get "dashboard", to: "dashboard#index"

  # Quizzes
  resources :quizzes, only: [:index, :show]

  # Reflectional Symmetry Puzzles
  resources :reflectional_symmetry_puzzles, only: [:index, :show], path: "puzzles/reflection"

  # API (AJAX endpoints)
  namespace :api do
    get "quiz_feedback", to: "quiz_feedback#show"
    resources :answer_rows, only: [:create]
    resources :puzzle_entries, only: [:create]
  end

  # Admin
  namespace :admin do
    root "quiz_questions#index"
    resources :quiz_questions
    resources :reflectional_symmetry_puzzles, path: "puzzles/reflection"
  end
end
