class Version < ApplicationRecord
  # `type` est une colonne reservee par Rails (Single Table Inheritance).
  # Sans cette ligne, sauver type: "live" fait chercher une classe Live et plante.
  self.inheritance_column = nil

  # Les seuls styles de version qu'on accepte. Reprend la liste ecrite dans la
  # PR #9 (elle s'appelait KINDS a l'epoque, avant le renommage type -> style).
  # Le seed n'utilise pour l'instant que studio / live / acoustic.
  STYLES = %w[studio live acoustic remix cover demo remaster].freeze

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
