class List < ApplicationRecord
  belongs_to :user
  has_many :bookmarks
  has_many :versions, through: :bookmarks

  # Deux users peuvent avoir une liste "Covers", mais pas le meme user deux fois.
  validates :title, presence: true,
                    length: { maximum: 100 },
                    uniqueness: { scope: :user_id, case_sensitive: false }
end
