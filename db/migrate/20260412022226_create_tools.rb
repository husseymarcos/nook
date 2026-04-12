class CreateTools < ActiveRecord::Migration[8.1]
  def change
    create_table :tools do |t|
      t.string :name
      t.string :description
      t.string :platform
      t.string :category
      t.boolean :is_default

      t.timestamps
    end
  end
end
