Rails.application.routes.draw do
    # ユーザー登録、ログイン/ログアウト用のルート
    resources :users, only: [:create, :index]
    resources :sessions, only: [:create, :destroy]
  
    # MealsController のルーティング
    resources :meals, only: [:create] # 新しい食事を作成するアクション
  
    # RecipesController のルーティング
    post 'recipes/recommend', to: 'recipes#recommend' # レシピを提案するアクション
  
  
end
