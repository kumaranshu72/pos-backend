class CreateBills < ActiveRecord::Migration[5.2]
  def change
    create_table :bills do |t|
      t.float :bill_amount
      t.float :service_charge
      t.float :grand_total

      t.timestamps
    end
  end
end
