class User < ApplicationRecord
    has_one :daily_requirement
    has_many :meals
    has_one :character
    has_many :nutrients
    # ユーザー作成時にデフォルトの要求を設定
  after_create :create_default_daily_requirement

  private

  def create_default_daily_requirement
    DailyRequirement.create(user: self)
  end
end
