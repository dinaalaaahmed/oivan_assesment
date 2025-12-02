class CreateUrls < ActiveRecord::Migration[8.1]
  def change
    create_table :urls do |t|
      t.string :original_url
      t.string :url_hash

      t.timestamps
    end
  end
end
