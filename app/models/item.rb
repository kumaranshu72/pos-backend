class Item < ApplicationRecord
  #has_many :ItemTagRelationship
  #has_many :BillItem
  validates :name, presence: true
  validates :price, presence: true
end
