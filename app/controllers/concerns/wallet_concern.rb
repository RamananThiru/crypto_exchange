module WalletConcern
  extend ActiveSupport::Concern
      
  """
    Before: Currency: 'btc', amount: 9.00
    After:  Currency: 'btc', amount: 12.00 (Deposited amount: 3 bitcoins)
  """
  def deposit_money_to_wallet(params, user, currency)
    wallet = get_wallet(user, currency)
    ActiveRecord::Base.transaction do
      wallet.balance += params[:amount].to_f
      wallet.save!
    end
    render json: { status: 'success', msg: 'successfully deposited funds', payload: get_wallet_payload(wallet) }, status: :ok

  rescue StandardError => e
    render json: { success: 'failure', message: 'Unable to add funds to the wallet. Please Contact support'}, status: :unprocessable_entity
  end

  """
    Before: Currency: 'btc', amount: 9.00
    After:  Currency: 'btc', amount: 6.00 (Withdrawal amount: 3 bitcoins)
  """
  def withdraw_money_from_wallet(params, user, currency)
    wallet = get_wallet(user, currency)

    ActiveRecord::Base.transaction do
      wallet.balance -= params[:amount].to_f
      wallet.save!
    end
    render json: { status: 'success', msg: 'successfully withdrawn funds', payload: get_wallet_payload(wallet) }, status: :ok

  rescue StandardError => e
    error_message = e.message.include?('Validation failed:') ? e.message.split(':').last&.strip : 'Unable to withdraw funds from wallet. Please Contact support'
    render json: { success: 'failure', msg: error_message }, status: :unprocessable_entity
  end

  def gather_all_wallet_balance(params, user)
    return render json: { status: 'sucess', msg: 'Invalid User'}, status: :unauthorized if user.blank?

    render json: { status: 'success', msg: 'successfully fetched funds', payload: user.get_all_wallets_payload }, status: :ok

  rescue StandardError => e
    render json: { success: 'failure', message: 'Unable to get your wallets information'}, status: :unprocessable_entity
  end
  


  private

  def get_wallet(user, currency)
    user.wallets.find_or_initialize_by(currency: currency)
  end

  def get_wallet_payload(wallet)
    { balance: wallet.balance, currency: wallet.currency.currency_type}
  end
end  