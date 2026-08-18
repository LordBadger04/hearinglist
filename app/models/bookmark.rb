class Bookmark < ApplicationRecord
  belongs_to :version
  belongs_to :list

  # Empeche d'ajouter deux fois la meme version dans la meme liste.
  validates :version_id, uniqueness: {
    scope: :list_id,
    message: "est deja dans cette liste"
  }
end
