class CreateStacks < ActiveRecord::Migration[8.1]
  def change
    create_table :stacks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
