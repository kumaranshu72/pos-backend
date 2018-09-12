class CreateBills < ActiveRecord::Migration[5.2]
  def change
    create_table :bills do |t|
      t.float :billAmount
      t.float :serviceCharge
      t.float :grandTotal
      t.timestamps
    end
  end
end
