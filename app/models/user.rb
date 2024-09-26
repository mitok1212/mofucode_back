class User < ApplicationRecord
    has_one :daily_requirement
    has_many :meals
    has_one :character
    has_one :nutrient_deficiency

    validates :username, presence: true
    validates :email, presence: true, uniqueness: true
    validates :age, :weight, :height, :gender, presence: true

    after_create :set_default_requirements

    
    #API呼び出す
    apicall = Utils::ApiCall.new
    
    private

    def set_default_requirements
      # 年齢や性別から基礎代謝や必要栄養素を計算
      DailyRequirement.create(user: self, carbohydrates: 250, proteins: 50, fats: 70)
      NutrientDeficiency.create(user: self)
      Character.create(user: self)
    end
end
