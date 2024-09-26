class NutrientDeficiency < ApplicationRecord
    belongs_to :user

    def update_deficiency(nutrients)
      self.carbohydrates_deficiency -= nutrients[:carbohydrates]
      self.proteins_deficiency -= nutrients[:proteins]
      self.fats_deficiency -= nutrients[:fats]
      self.save
    end
end
