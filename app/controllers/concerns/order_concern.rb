module OrderConcern
  extend ActiveSupport::Concern

  def create_order(params, user)
    order = nil

    ActiveRecord::Base.transaction do
      order = user.orders.create(build_order_attribute_payload(params))
    end
    render json: { status: 'sucess', message: 'Successfully created', payload: order.as_json }, status: :ok

  rescue StandardError => e
    render json: { status: 'failure', msg: 'Order creation failed'}, status: :unprocessable_entity
  end

  def build_order_attribute_payload(params)
    currency_hash = Currency.where(currency_type: params.to_unsafe_h.slice(:currency_buy, :currency_sell).values)
                            .pluck(:currency_type, :id)
                            .to_h
    {
      side: params[:side],
      base_currency_id: currency_hash[params[:currency_buy]],
      quote_currency_id: currency_hash[params[:currency_sell]],
      price: params[:price].to_f,
      volume: params[:volume].to_f,
      status: 'pending'
    }
  end

  def cancel_order(params)
    order = Order.find_by(id: params[:order_id])
    return render json: { status: 'failure', message: 'Invalid Order' } if order.blank?

    ActiveRecord::Base.transaction do
      order.update!(status: 'cancelled')
    end

    render json: { status: 'success', Message: 'Sucessfully Created', payload: '' }, status: :ok
  rescue StandardError => e
    render json: { status: 'failure', Message: 'Failed to cancel order' }, status: :unprocessable_entity
  end
end