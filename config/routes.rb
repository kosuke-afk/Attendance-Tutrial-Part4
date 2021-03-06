Rails.application.routes.draw do

  root 'static_pages#top'
  get '/signup', to: 'users#new'
  
  # ログイン機能
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      # attendances/と記入することによりusers/:id/attendances/edit_one_monthが追加される
      get 'attendances/edit_one_month'
      # 上と同じ要領でusers/:id/attendances/update_one_monthを追加している。
      patch 'attendances/update_one_month'
    end
    # usersリソースの中に含ませることにより:usersリソースと関連づけたルーティングを設定できる。 only: updateにより使うルーティングを制限
    resources :attendances, only: :update 
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
