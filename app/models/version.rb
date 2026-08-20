class Version < ApplicationRecord
  # `type` est une colonne reservee par Rails (Single Table Inheritance).
  # Sans cette ligne, sauver type: "live" fait chercher une classe Live et plante.
  self.inheritance_column = nil

  # Les trois seules valeurs presentes dans le seed
  # (app/assets/data/random_tracks_seed_copy.json). Le formulaire de creation
  # s'en sert pour construire son menu deroulant.
  STYLES = %w[studio live acoustic].freeze

  # Champs virtuels du formulaire de creation : l'utilisateur tape un titre et
  # un nom en texte libre, VersionsController les transforme en Song et Artist.
  # Ils ne sont pas stockes en base.
  attr_accessor :song_title, :artist_name

  # Bornes plausibles pour l'annee d'une version enregistree.
  FIRST_RECORDING_YEAR = 1860

  belongs_to :artist
  belongs_to :song
  has_many :bookmarks
  has_many :lists, through: :bookmarks

  validates :style, presence: true, inclusion: { in: STYLES }

  validates :year, numericality: {
                     only_integer: true,
                     greater_than_or_equal_to: FIRST_RECORDING_YEAR,
                     less_than_or_equal_to: ->(_version) { Date.current.year }
                   },
                   allow_nil: true
end
