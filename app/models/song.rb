class Song < ApplicationRecord
  has_many :versions
  has_many :artists, through: :versions

  # Une chanson sans titre n'a aucun sens, et on ne veut pas deux fiches
  # "Hallelujah" / "hallelujah" qui se dupliquent dans la base.
  validates :title, presence: true,
                    length: { maximum: 200 },
                    uniqueness: { case_sensitive: false }
end
