class User < ApplicationRecord
    has_one :daily_requirement
    has_many :meals
    has_one :character
    has_many :nutrients
end
