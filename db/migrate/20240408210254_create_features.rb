class CreateFeatures < ActiveRecord::Migration[7.1]
  def change
    create_table :features do |t|
      t.string :external_id, null: false
      t.decimal :magnitude, precision: 8, scale: 2, null: false
      t.string :place, null: false, limit: 255
      t.timestamp :time
      t.boolean :tsunami
      t.string :mag_type, null: false, limit: 50
      t.string :title, null: false, limit: 255
      t.string :url, null: false, limit: 255
      t.decimal :longitude, precision: 10, scale: 6, null: false
      t.decimal :latitude, precision: 10, scale: 6, null: false
      t.timestamps
    end
  end
end
