class CreateBillItems < ActiveRecord::Migration[5.2]
  def change
    create_table :bill_items do |t|
      t.integer :billId
      t.integer :itemId
      t.integer :itemQty
      t.float :unitPrice
      t.timestamps
    end
  end
end
