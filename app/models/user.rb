class User < ApplicationRecord
    has_one :daily_requirement
    has_many :meals
    has_one :character
    has_one :nutrient_deficiency

    validates :username, presence: true
    validates :email, presence: true, uniqueness: true
    validates :age, :weight, :height, :gender, presence: true    
end
