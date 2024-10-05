class Nutrient < ApplicationRecord
    belongs_to :meal
    belongs_to :user
    def set_default_requirements
        # 年齢、性別、体重、身長を基に1日の総消費カロリー(基礎代謝*1.2)を計算
        tdee = calculate_tdee(user.age, user.gender, user.weight, user.height)
       
        # 必要カロリーの配分（炭水化物50-65% 1g 4kcal, タンパク質13-20% 1g 4kcal, 脂質20-30% 1g 9kcal）
        need_carbohydrates = (tdee * 0.58) / 4
        need_proteins = (tdee * 0.17) / 4
        need_fats = (tdee * 0.25) / 9
      
        DailyRequirement.create(user: user, carbohydrates: carbohydrates, proteins: proteins, fats: fats)
        NutrientDeficiency.create(user: user)
        Character.create(user: user)
    end

    def calculate_tdee(age, gender, weight, height)
      #ミフリンセイントジョー公式基礎代謝量(bmr)を求め、*1.2で総消費カロリー(ほぼ運動しない人)を求める
      if gender == 'male'
        (-161 + (10 * weight) + (6.25 * height) - (5 * age) )* 1.2
      else
        (5 + (10 * weight) + (6.25 * height) - (5 * age)) * 1.2
      end
    end  
end
