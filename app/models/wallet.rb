class Wallet < ApplicationRecord
  belongs_to :user
  belongs_to :currency
  

  validate :balance_invalid?

  def balance_invalid?
    errors.add(:balance, 'Insufficient Balance amounts for withdrawal') if self.balance < 0
  end
end