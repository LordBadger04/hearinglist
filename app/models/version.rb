class Version < ApplicationRecord
  # `type` est une colonne reservee par Rails (Single Table Inheritance).
  # Sans cette ligne, sauver type: "live" fait chercher une classe Live et plante.
  self.inheritance_column = nil


  # Bornes plausibles pour l'annee d'une version enregistree.
  FIRST_RECORDING_YEAR = 1860

  belongs_to :artist
  belongs_to :song
  has_many :bookmarks
  has_many :lists, through: :bookmarks


  validates :style, presence: true

  validates :year, numericality: {
                     only_integer: true,
                     greater_than_or_equal_to: FIRST_RECORDING_YEAR,
                     less_than_or_equal_to: ->(_version) { Date.current.year }
                   },
                   allow_nil: true
end
