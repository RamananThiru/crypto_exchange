class CreateWallets < ActiveRecord::Migration[7.2]
  def change
    create_table :wallets do |t|
      t.references :currency, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :balance, precision: 15, scale: 3, default: 0.0

      t.timestamps
    end
  end
end
