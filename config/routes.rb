Rails.application.routes.draw do
  devise_for :users
  get 'pages/home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "pages#home"

  resources :projects

  resources :my_bugs do
    member do
     post :bug_status
    end
  end

end
