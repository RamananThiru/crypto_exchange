module WalletConcern
  extend ActiveSupport::Concern

  def deposit_money_to_wallet(params)
    # find user from params due to lack of token based authentication
    user = User.find_by(id: params[:user_id])

    # Join is used as the currency used in wallet and orders has to have same source of truth
    # Source of truth for available currencies will be in currency table
    currency = Currency.find_by(currency_type: params[:currency])

    return render json: { status: 'failure', message: 'Invalid currency type'} if currency.blank?

    wallet = Wallet.joins(:user, :currency)
                   .where(users: { id: params[:user_id] }, currencies: { id: currency.id })
                   .first
    
    """
      Before: Currency: 'btc', amount: 9.00
      After:  Currency: 'btc', amount: 12.00 (Deposited amount: 3 bitcoins)
    """
    ActiveRecord::Base.transaction do
      if wallet.present?
        updated_balance = wallet.balance + params[:amount].to_f
        wallet.update!(balance: updated_balance)
      else
        wallet = user.wallets.new(currency: currency, balance: params[:amount])
        wallet.save!
      end
    end
    
    payload = { balance: wallet.balance, currency: currency.currency_type}

    render json: { status: 'success', msg: 'successfully deposited funds', payload: payload }, status: :ok

  rescue StandardError => e
    render json: { success: 'failure', message: 'Unable to add funds to the wallet. Please Contact support'}
  end
end  