class CreateStackTools < ActiveRecord::Migration[8.1]
  def change
    create_table :stack_tools do |t|
      t.references :stack, null: false, foreign_key: true
      t.references :tool, null: false, foreign_key: true

      t.timestamps
    end

    add_index :stack_tools, [ :stack_id, :tool_id ], unique: true
  end
end
