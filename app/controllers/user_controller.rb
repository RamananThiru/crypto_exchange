class UserController < ApiController
  include UsersConcern

  before_action :validate_signup_params, only: [:signup]

  # POST /users/signup
  def signup
    create_user(user_params)
  end

  private

  def validate_signup_params
    if user_params[:email].blank?
      return render json: { status: 'failure', message: 'Email is required' }, status: :bad_request
    elsif user_params[:password].blank?
      return render json: { status: 'failure', message: 'Password is required' }, status: :bad_request
    end
  end

  # Strong parameters to allow only permitted attributes
  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
