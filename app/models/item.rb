class Item < ApplicationRecord
  #has_many :ItemTagRelationship
  #has_many :BillItem
  validates :name, presence: true, :uniqueness => {:case_sensitive => false}
  validates :price, presence: true
end
