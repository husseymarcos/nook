class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.datetime :premium_until
      t.integer :searches_this_month, default: 0
      t.datetime :last_search_reset_at

      t.timestamps
    end
    add_index :users, :email_address, unique: true
  end
end
