class Bookmark < ApplicationRecord
  belongs_to :version
  belongs_to :list
end
