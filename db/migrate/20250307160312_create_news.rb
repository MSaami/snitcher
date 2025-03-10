class CreateNews < ActiveRecord::Migration[8.0]
  def change
    create_table :news do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.string :source, null: false
      t.references :category, null: false, foreign_key: true
      t.string :author
      t.string :published_at
      t.string :provider_id

      t.timestamps

      t.index [:provider_id, :source], unique: true

    end

  end
end
