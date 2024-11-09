class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable\

  has_many :wallets, dependent: :destroy
  has_many :orders, dependent: :destroy


  def get_all_wallets_payload
    wallets.find_each.map do |wallet|
      { balance: wallet.balance, currency: wallet.currency.currency_type }
    end
  end
end
