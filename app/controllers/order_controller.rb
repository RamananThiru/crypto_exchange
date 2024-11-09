class OrderController < ApiController
  include OrderConcern
  before_action :validate_user, only: [:create]

  # POST /order/create
  def create
    create_order(params, user)
  end

  # PUT /order/cancel
  def cancel
    cancel_order(params)
  end


  def validate_user
    user = User.find_by(id: params[:user_id])

    return render json: { success: 'failure', message: 'User not found' }, status: :unauthorized
  end
end