class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :buyer
      t.string :description
      t.decimal :unit_price
      t.integer :amount
      t.string :address
      t.string :provider

      t.timestamps null: false
    end
  end
end
