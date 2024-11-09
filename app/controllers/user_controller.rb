class UserController < ApiController
  include UsersConcern
  # TODO: API authentication was not part of the requirement document

  before_action :validate_account_credentials_params, only: [:signup, :login]

  # POST /users/signup
  def signup
    create_user(user_params)
  end

  def login
    user_login(user_params)
  end

  private

  def validate_account_credentials_params
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
