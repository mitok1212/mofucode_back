class MealController < ApplicationController
    before_action :authenticate_user!
#レシピ考案のapi呼び出すコード追加する
#キャラクター育成のレベル更新入れる(不足栄養素を更新辺りに入れられそう)

  # 朝食、昼食、夕食の選択フォームを表示
  def new
    @meal = Meal.new
  end

  # 食事内容を保存して栄養素を計算
  def create
    @meal = current_user.meals.build(meal_params)
    
    if @meal.save
      # APIを呼び出して栄養素を計算
      nutrients = Model::Api.new.calculate_nutrients(@meal.food_items)
      
      # Nutrientモデルに栄養素を保存
      Nutrient.create(
        user: current_user,
        meal: @meal,
        carbohydrates: nutrients[:carbohydrates],
        proteins: nutrients[:proteins],
        fats: nutrients[:fats]
      )
      
      # 不足栄養素を更新
      current_user.nutrient_deficiency.update_deficiency(nutrients)
      
      redirect_to meal_path(@meal), notice: "食事が保存され、栄養素が更新されました"
    else
      render :new
    end
  end

  # 食事と栄養素を表示
  def show
    @meal = current_user.meals.find(params[:id])
    @nutrient = @meal.nutrient
    @deficiency = current_user.nutrient_deficiency
  end

  private

  def meal_params
    params.require(:meal).permit(:meal_type, :food_items)
  end
end
