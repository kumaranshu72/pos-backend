class CreateBillItems < ActiveRecord::Migration[5.2]
  def change
    create_table :bill_items do |t|
      t.integer :bill_id
      t.integer :item_id
      t.integer :item_qty
      t.float :unit_price

      t.timestamps
    end
  end
end
