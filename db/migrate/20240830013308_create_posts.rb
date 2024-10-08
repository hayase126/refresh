class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.references :user, foreign_key: true
      t.string :post_image

      t.timestamps
    end
  end
end
