Rails.application.routes.draw do
  resources :tags
  resources :items
  resources :stores
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "login", to: "users#login", as: "login"
  post "login", to: "users#recieve_login_info", as: "recieve_login_info"
  get "choosetype", to: "users#choosetype", as: "choose_type"
  get "store/:name" , to: "stores#storepage", as: "store_page"
  get "user/:username", to: "users#userpage", as: "user_page"
  post "store/addbucket/:item_id", to: "stores#incitem", as: "inc_item"
  post "store/rembucket/:item_id", to: "stores#decitem", as: "dec_item"
  get "confirmpur/:user_id", to: "stores#confirmpur", as: "store_confirm_get"
  post "confirmpur/:user_id", to: "stores#recordpur", as: "store_confirm_post"
  get "tracking", to: "users#track", as: "track_page"
  post "store/:name/fav/:item_id", to: "stores#favitem", as: "store_fav_item"
  post "store/:name/unfav/:item_id", to: "stores#unfavitem", as: "store_unfav_item"
  get "order/:order_id", to: "users#vieworder", as: "user_view_order"
  post "comment", to: "stores#addcomment", as: "add_comment"
end
