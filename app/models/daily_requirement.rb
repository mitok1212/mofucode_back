class DailyRequirement < ApplicationRecord
    belongs_to :user
    def update_nutrients(nutrients)
        # 栄養素を加算
        self.carbohydrates += nutrients[:carbohydrates]
        self.proteins += nutrients[:proteins]
        self.fats += nutrients[:fats]
        # 変更を保存
        self.save
    end
end
