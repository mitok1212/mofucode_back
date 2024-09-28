class Character < ApplicationRecord
    belongs_to :user
    belongs_to :nutrient_deficiency

    # キャラクターの成長レベルを更新するメソッド
    def update_growth_level(nutrient_deficiencies)
    
        # すべての不足している栄養素が0かチェック
        if @nutrient_deficiency.carbohydrates_deficiency == 0 && @nutrient_deficiency.proteins_deficiency ==0 && @nutrient_deficiency.fats_deficiency == 0
            self.growth_level += 1
            self.save  # 変更を保存
            puts "Growth level increased to #{self.growth_level}."
        else
            #達成できなかった日数をカウント
            self.not_star += 1
            self.save
            puts "Nutrient deficiencies exist: Carbs: #{carbohydrates_deficiency}, Proteins: #{proteins_deficiency}, Fats: #{fats_deficiency}."
        end
    end
end
