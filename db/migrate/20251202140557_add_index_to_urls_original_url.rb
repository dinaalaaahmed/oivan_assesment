class AddIndexToUrlsOriginalUrl < ActiveRecord::Migration[8.1]
  def change
    add_index :urls, :original_url, unique: true
  end
end
