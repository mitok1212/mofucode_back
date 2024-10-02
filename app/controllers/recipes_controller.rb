class RecipesController < ApplicationController
        before_action :authenticate_user!
      
        # レシピを提案するためのアクション
        def recommend
          # 現在のユーザーの栄養不足情報を取得
          deficiency = current_user.nutrient_deficiency
      
          # 不足している栄養素の情報をChatGPT APIに渡してレシピを提案
          if deficiency
            api_client = Model::Api.new
            recommended_recipes = api_client.recommend_recipes({
              carbohydrates: deficiency.carbohydrates_deficiency,
              proteins: deficiency.proteins_deficiency,
              fats: deficiency.fats_deficiency
            })
      
            # レシピをJSON形式でフロントエンドに返す
            render json: {
              message: "レシピの提案が完了しました",
              recipes: recommended_recipes
            }, status: :ok
          else
            # 栄養不足データがない場合のエラーレスポンス
            render json: { error: "栄養不足データが見つかりません" }, status: :not_found
          end
        end
      
      
end
