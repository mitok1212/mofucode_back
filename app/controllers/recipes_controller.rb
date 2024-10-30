class RecipesController < ApplicationController
        before_action :authenticate_user!
      
        # レシピを提案するためのアクション
        def recommend
          # 現在のユーザーの栄養不足情報を取得
          deficiency = current_user.nutrient_deficiency
      
          # 不足している栄養素の情報をChatGPT APIに渡してレシピを提案
          if deficiency
            api_client = RecipeApi::Api.new
            recommended_recipes = api_client.recommend_recipes({
              carbohydrates: deficiency.carbohydrates_deficiency,
              proteins: deficiency.proteins_deficiency,
              fats: deficiency.fats_deficiency
            })
             # レシピのタイトルと内容をそれぞれ抽出して配列に格納
            recipe_titles = recommended_recipes.map { |recipe| recipe[:title] }
            recipe_contents = recommended_recipes.map { |recipe| recipe[:content] }

            # レシピをJSON形式でフロントエンドに返す
            render json: {
              message: "レシピの提案が完了しました",
              recipe_titles : recipe_titles,
              recipe_contents: recipe_contents 
            }, status: :ok
          else
            # 栄養不足データがない場合のエラーレスポンス
            render json: { error: "栄養不足データが見つかりません" }, status: :not_found
          end
        end
      
      
end
