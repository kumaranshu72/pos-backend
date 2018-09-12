class CreateHasTags < ActiveRecord::Migration[5.2]
  def change
    create_table :has_tags do |t|
      t.string :name
      t.timestamps
    end
  end
end
