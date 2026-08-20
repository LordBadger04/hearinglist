class AddSuggestionsToMessage < ActiveRecord::Migration[8.1]
  def change
    add_column :messages, :suggestions, :jsonb, default: []
  end
end
