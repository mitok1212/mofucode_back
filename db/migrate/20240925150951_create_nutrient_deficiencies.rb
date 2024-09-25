class CreateNutrientDeficiencies < ActiveRecord::Migration[6.1]
  def change
    create_table :nutrient_deficiencies do |t|
      #不足している栄養素のリストとその更新情報を保存
      t.references :user, foreign_key: true
      t.float :carbohydrates_deficiency, default: 0
      t.float :proteins_deficiency, default: 0
      t.float :fats_deficiency, default: 0
      t.timestamps
    end
  end
end
