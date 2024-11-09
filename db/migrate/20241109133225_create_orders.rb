class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.integer :side
      t.references :base_currency, null: false, foreign_key: { to_table: :currencies }
      t.references :quote_currency, null: false, foreign_key: { to_table: :currencies }
      t.float :price
      t.float :volume
      t.integer :status
      t.references :user, null: false, foreign_key: true  # Add this line for user_id

      t.timestamps
    end
  end
end
