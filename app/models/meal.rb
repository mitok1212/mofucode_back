class Meal < ApplicationRecord
    belongs_to :user
    has_many :nutrients

    # 食事の情報が正しいか検証するメソッド
  validates :meal_type, inclusion: { in: %w[breakfast lunch dinner], message: "must be breakfast, lunch, or dinner" }
end
