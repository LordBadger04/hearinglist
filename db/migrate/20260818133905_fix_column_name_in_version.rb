class FixColumnNameInVersion < ActiveRecord::Migration[8.1]
  def change
    rename_column :version, :type, :style
  end
end
