class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.references :company, null: false, foreign_key: true
      t.string :email, null: false, limit: 100
      t.string :password_digest, null: false
      t.integer :role, default: 1, null: false
      t.string :first_name, limit: 50
      t.string :last_name, limit: 50
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, [ :company_id, :email ], unique: true
    add_index :users, :role
    add_index :users, :active
  end
end
