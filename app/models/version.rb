class Version < ApplicationRecord
  # `type` est une colonne reservee par Rails (Single Table Inheritance).
  # Sans cette ligne, sauver type: "live" fait chercher une classe Live et plante.
  self.inheritance_column = nil

  # Les seuls types de version qu'on accepte.
  KINDS = %w[studio live acoustic remix cover demo remaster].freeze

  # Bornes plausibles pour l'annee d'une version enregistree.
  FIRST_RECORDING_YEAR = 1860

  belongs_to :artist
  belongs_to :song
  has_many :bookmarks
  has_many :lists, through: :bookmarks

  validates :url, presence: true,
                  format: { with: %r{\Ahttps?://\S+\z},
                            message: "doit commencer par http:// ou https://" },
                  uniqueness: { case_sensitive: false }

  validates :type, presence: true, inclusion: { in: KINDS }

  validates :year, numericality: {
                     only_integer: true,
                     greater_than_or_equal_to: FIRST_RECORDING_YEAR,
                     less_than_or_equal_to: ->(_version) { Date.current.year }
                   },
                   allow_nil: true
end
