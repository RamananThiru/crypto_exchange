class WalletController < ApiController
  include WalletConcern

  before_action :validate_assign_wallet_attributes, only: [:deposit, :withdrawal]

  # POST /users/deposit
  # Purpose: Adds money to the crypto wallet
  def deposit
    deposit_money_to_wallet(params, @user, @currency)
  end

  # POST /users/withdrawal
  def withdrawal
    withdraw_money_from_wallet(params, @user, @currency)
  end

  # GET /users/balances
  def balances
    user = User.find_by(id: params[:user_id])
    gather_all_wallet_balance(params, user)
  end

  private

  def validate_assign_wallet_attributes
    # find user from params due to lack of token based authentication
    @user = User.find_by(id: params[:user_id])
    return render json: { status: 'failure', message: 'User not found'}, status: :bad_request if @user.blank?

    # Join is used as the currency used in wallet and orders has to have same source of truth
    # Source of truth for available currencies will be in currency table
    @currency = Currency.find_by(currency_type: params[:currency])
    return render json: { status: 'failure', message: 'Invalid currency type'} if @currency.blank?
  end
end