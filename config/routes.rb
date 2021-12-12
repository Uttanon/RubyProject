Rails.application.routes.draw do
  resources :tags
  resources :items
  resources :stores
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "login", to: "users#login"
  post "login", to: "users#recieve_login_info", as: "recieve_login_info"
  get "choosetype", to: "users#choosetype", as: "choose_type"
  get "store/:name" , to: "stores#storepage", as: "store_page"
  get "user/:username", to: "users#userpage", as: "user_page"
  post "store/:name/add/:item_id", to: "stores#incitem", as: "inc_item"
  post "store/:name/rem/:item_id", to: "stores#decitem", as: "dec_item"
  get "store/:name/confirm", to: "stores#confirmpur", as: "store_confirm_get"
  post "store/:name/confirm", to: "stores#recordpur", as: "store_confirm_post"
  get "tracking", to: "stores#track", as: "track_page"
end
