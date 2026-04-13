class RevertRenameModels < ActiveRecord::Migration[8.1]
  def change
    # Remove foreign keys first
    remove_foreign_key :chats, :ai_models
    remove_foreign_key :messages, :ai_models

    # Rename foreign key columns back
    rename_column :chats, :ai_model_id, :model_id
    rename_column :messages, :ai_model_id, :model_id

    # Rename table back
    rename_table :ai_models, :models

    # Add foreign keys back
    add_foreign_key :chats, :models
    add_foreign_key :messages, :models
  end
end
