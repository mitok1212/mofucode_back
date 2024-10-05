class CreateUsers< ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      #ユーザーの基本情報やログインに関するデータを保存
      t.string :username, null: false
      t.string :email, null: false, unique: true
      t.string :password_digest, null: false
      t.integer :age
      t.float :double :weight
      t.float :double :height
      t.string :gender
      t.timestamps
    end
    #emailにユニーク制約(重複をさせない)を追加
    add_index :users, :email, unique: true
  end
end
