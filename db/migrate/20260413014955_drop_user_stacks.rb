class DropUserStacks < ActiveRecord::Migration[8.1]
  def up
    drop_table :user_stacks
  end

  def down
    create_table :user_stacks do |t|
      t.integer :user_id, null: false
      t.integer :tool_id, null: false
      t.timestamps
    end

    add_index :user_stacks, :user_id
    add_index :user_stacks, :tool_id
    add_foreign_key :user_stacks, :users
    add_foreign_key :user_stacks, :tools
  end
end
