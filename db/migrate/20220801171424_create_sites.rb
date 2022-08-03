class CreateSites < ActiveRecord::Migration[6.1]
  def change
    create_table :sites do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.datetime :last_visit, null: false

      t.timestamps
    end
  end
end
