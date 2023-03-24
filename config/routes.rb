Rails.application.routes.draw do
  # routes for devise
  devise_for :users, controllers: {registrations: "users/registrations"}

  # Resources for admin users in the admin area
  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update]
    resources :workplaces, only: [:index, :create, :new, :edit, :show, :update, :destroy]
    resources :work_times, only: [:edit, :update]
    get 'user_report' => 'report#user_report', as: 'user_report'
    get 'workplace_report' => 'report#workplace_report', as: 'workplace_report'
    get 'download_excel' => 'report#download_excel', as: 'download_report'
    root 'dashboard#index'
  end

  # Resources for all users
  resources :comments, only: [:index, :create]
  resources :monthly_works, only: [:index, :show]
  resources :work_times, only: [:new, :edit, :create, :update, :show]

  #locales path
  get 'locale/:locale' => "home#switch_locale", as: 'switch_locale'

  #mode path
  get 'mode/:mode' => "home#switch_mode", as: 'switch_mode'

  # root path
  root 'home#index'
end
