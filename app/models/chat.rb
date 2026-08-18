class Chat < ApplicationRecord
  belongs_to :user
  has_many :messages

  # Le titre est optionnel : un chat peut etre cree avant qu'on sache
  # de quoi il parle, puis renomme d'apres le premier message.
  validates :title, length: { maximum: 120 }, allow_blank: true
end
