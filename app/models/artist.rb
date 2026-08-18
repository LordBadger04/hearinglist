class Artist < ApplicationRecord
  has_many :versions
  has_many :songs, through: :versions

  validates :name, presence: true,
                   length: { maximum: 100 },
                   uniqueness: { case_sensitive: false }
end
