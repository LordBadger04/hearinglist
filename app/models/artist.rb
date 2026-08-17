class Artist < ApplicationRecord
  has_many :versions
  has_many :songs, through: :versions
end
