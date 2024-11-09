class WalletController < ApiController
  include WalletConcern

  # POST /users/deposit
  # Purpose: Adds money to the crypto wallet
  def deposit
    # If wallet is already present , use the same or else create it
    deposit_money_to_wallet(params)
  end
end