module UserConcern
  extend ActiveSupport::Concern

  def create_user(user_params)
    @user = User.new(user_params)

    return render json: build_user_sucess_response, status: :ok if @user.save!
      
  rescue StandardError => e
    # Skip logging sensitive details like email/password
    Rails.logger.info("User Signup error: #{e.message}")
    render json: { status: 'failure', message: 'Unable to save user' }, status: :unprocessable_entity
  end

  def user_login(user_params)
    user = User.find_by(email: user_params[:email])
    if user.blank? || !user.valid_password?(user_params[:password])
      return render json: { status: 'failure', message: 'Unauthorized' }
    end  

    render json: { status: 'success', message: 'login successful'}
  end


  def build_user_sucess_response
    { 
      status: 'success',
      message: 'User successfully signed up',
      payload: {
        user_id: @user.id
      }
    }
  end
end
  