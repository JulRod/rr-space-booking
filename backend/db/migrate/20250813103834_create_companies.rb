class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :subdomain, null: false, limit: 50
      t.string :name, null: false, limit: 100
      t.text :settings
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :companies, :subdomain, unique: true
    add_index :companies, :active
  end
end
