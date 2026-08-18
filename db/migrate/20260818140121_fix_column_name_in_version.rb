class FixColumnNameInVersion < ActiveRecord::Migration[8.1]
  def change
    rename_column :versions, :type, :style
  end
end
