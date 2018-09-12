class CreateItemTagsRelation < ActiveRecord::Migration[5.2]
  def change
    create_table :item_tags_relations do |t|
      t.integer :itemId
      t.integer :tagId
      t.timestamps
    end
  end
end
