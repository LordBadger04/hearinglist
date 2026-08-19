class AddImageUrlToList < ActiveRecord::Migration[8.1]
  def change
    add_column :lists, :image_url, :string
  end
end
