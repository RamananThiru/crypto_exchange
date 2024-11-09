class CreateCurrencies < ActiveRecord::Migration[7.2]

  def change
    create_table :currencies do |t|
      t.string :currency_type, null: false
      
      t.timestamps
    end
  end
end 