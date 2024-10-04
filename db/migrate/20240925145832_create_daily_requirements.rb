class CreateDailyRequirements < ActiveRecord::Migration[6.1]
  def change
    #ユーザーの年齢や性別から計算される1日に必要な栄養素を保存
    create_table :daily_requirements do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.float :carbohydrates
      t.float :proteins
      t.float :fats

      t.timestamps
    end
  end
end
