class CreateMeals < ActiveRecord::Migration[6.1]
  def change
    create_table :meals do |t|
      #ユーザーが朝食、昼食、夕食に食べた食事の情報を記録
      t.references :user, foreign_key: true
      t.string :meal_type #breakfast,lunch,dinner
      t.string :food_items
      t.datetime :meal_time
      t.timestamps
    end
  end
end
