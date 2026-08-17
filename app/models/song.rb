class Song < ApplicationRecord
  has_many :versions
  has_many :artists, through: :versions
end
