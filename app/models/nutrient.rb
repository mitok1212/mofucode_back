class Nutrient < ApplicationRecord
    belongs_to :meal
    def set_default_requirements
        # 年齢、性別、体重、身長を基に1日の必要カロリーを計算
        bmr = calculate_bmr(age, gender, weight, height)
        
        # 必要カロリーの配分（炭水化物50-65%, タンパク質13-20%, 脂質20-30%）
        carbohydrates = (bmr * 0.58) / 4
        proteins = (bmr * 0.17) / 4
        fats = (bmr * 0.25) / 9
      
        DailyRequirement.create(user: self, carbohydrates: carbohydrates, proteins: proteins, fats: fats)
        NutrientDeficiency.create(user: self)
        Character.create(user: self)
      end
      
      def calculate_bmr(age, gender, weight, height)
        if gender == 'male'
          88.36 + (13.4 * weight) + (4.8 * height) - (5.7 * age)
        else
          447.6 + (9.2 * weight) + (3.1 * height) - (4.3 * age)
        end
      end
end
