Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "sites#index"

  resources :sites
  post "sites/submit_visit" => "sites#submit_visit"

  get "search" => "search#index"

end
