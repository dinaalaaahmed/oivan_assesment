class AddIndexToUrlsHashUrl < ActiveRecord::Migration[8.1]
  def change
    add_index :urls, :url_hash, unique: true
  end
end
