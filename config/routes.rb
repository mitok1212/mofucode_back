Rails.application.routes.draw do
    # ユーザー登録、ログイン/ログアウト用のルート
    resources :users, only: [:create, :index]
    resources :sessions, only: [:create, :destroy]
  

    # エラールーティング
    match "/404", to: "errors#not_found", via: :all
    match "/500", to: "errors#internal_server_error", via: :all
    match "/422", to: "errors#unprocessable_entity", via: :all
    # MealsController のルーティング
    resources :meals, only: [:create] # 新しい食事を作成するアクション
  
    # RecipesController のルーティング
    post 'recipes/recommend', to: 'recipes#recommend' # レシピを提案するアクション
    get 'users/csrf_token', to: 'users#csrf_token'
end