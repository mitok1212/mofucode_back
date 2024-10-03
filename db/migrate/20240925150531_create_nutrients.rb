class CreateNutrients < ActiveRecord::Migration[6.1]
  def change
    create_table :nutrients do |t|
      #栄養素の各食事ごとの摂取量を保存
      t.references :meal,null: false, foreign_key:true
      t.float :carbohydrates
      t.float :proteins
      t.float :fats
      t.timestamps
    end
  end
end
