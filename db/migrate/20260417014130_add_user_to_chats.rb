class AddUserToChats < ActiveRecord::Migration[8.1]
  def up
    add_reference :chats, :user, foreign_key: true

    # Backfill: orphan chats assigned to first user, or deleted if none exist
    if (first_user_id = execute("SELECT id FROM users ORDER BY id ASC LIMIT 1").first&.values&.first)
      execute "UPDATE chats SET user_id = #{first_user_id} WHERE user_id IS NULL"
    else
      execute "DELETE FROM messages WHERE chat_id IN (SELECT id FROM chats WHERE user_id IS NULL)"
      execute "DELETE FROM chats WHERE user_id IS NULL"
    end

    change_column_null :chats, :user_id, false
  end

  def down
    remove_reference :chats, :user, foreign_key: true
  end
end
