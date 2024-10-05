class User < ApplicationRecord
  has_one :daily_requirement
  has_many :meals
  has_one :character
  has_many :nutrients, through: :meals
  # ユーザー作成時にデフォルトの要求を設定
  after_create :create_default_daily_requirement

  private

  def create_default_daily_requirement
    unless DailyRequirement.create(user: self)
      Rails.logger.error "DailyRequirementの作成に失敗しました for User: #{self.id}"
    end
  end

end
