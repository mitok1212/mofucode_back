class MealsController < ApplicationController
    before_action :authenticate_user!
  
    # 新しい食事を作成するためのアクション
    def create
      # フロントエンドから送信された食事データを取得
      @meal = current_user.meals.new(meal_params)
  
      if @meal.save
        # ChatGPT API で食事データから栄養素を計算
        nutrients = Model::Api.new.calculate_nutrients(@meal.food_items)
  
        # ユーザーの栄養素データを更新
        nutrient_data = current_user.nutrient.update_nutrients(nutrients)
  
        # 不足分を更新
        current_user.nutrient_deficiency.update_deficiency(nutrient_data)
  
        # レスポンスをJSON形式でフロントエンドに返す
        render json: {
          message: "食事が保存されました",
          meal: @meal,
          nutrient_data: nutrient_data,
          deficiency: current_user.nutrient_deficiency
        }, status: :ok
      else
        # エラーが発生した場合、エラーメッセージを返す
        render json: { error: "食事の保存に失敗しました" }, status: :unprocessable_entity
      end
    end
  
    private
  
    # Strong Parameters：フロントエンドから送信される許可されたパラメータを定義
    def meal_params
      params.require(:meal).permit(:food_items, :meal_type)
    end
  end
  