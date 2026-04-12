class CreateUserStacks < ActiveRecord::Migration[8.1]
  def change
    create_table :user_stacks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tool, null: false, foreign_key: true

      t.timestamps
    end
  end
end
