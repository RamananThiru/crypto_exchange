module UsersConcern
  extend ActiveSupport::Concern

  def create_user(user_params)
    @user = User.new(user_params)

    return render json: build_user_sucess_response, status: :ok if @user.save!
      
    rescue StandardError => e
      render json: { status: 'failure', message: 'Unable to save user' }, status: :unprocessable_entity
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
  