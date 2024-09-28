class CreateCharacters < ActiveRecord::Migration[6.1]
  def change
    create_table :characters do |t|
      #キャラクターの成長状況を保存
      t.references :user, foreign_key: true
      t.integer :growth_level, default: 1
      t.integer :not_star, default: 0

      t.timestamps
    end
  end
end
