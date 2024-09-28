class NutrientDeficiency < ApplicationRecord
    belongs_to :user

    def update_deficiency(nutrients)
      #3大栄養素の不足分を計算(マイナスにならない)
      self.carbohydrates_deficiency = [self.carbohydrates_deficiency - nutrients[:carbohydrates], 0].max
      self.proteins_deficiency = [self.proteins_deficiency - nutrients[:proteins], 0].max
      self.fats_deficiency = [self.fats_deficiency - nutrients[:fats], 0].max
      self.save        
    end
end
