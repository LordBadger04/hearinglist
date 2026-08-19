class CorrectVersionColumn < ActiveRecord::Migration[8.1]
  def change
    rename_column :versions, :url, :version_url
    remove_column :versions, :version_, :string
  end
end
