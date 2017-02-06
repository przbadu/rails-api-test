class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    
    if @user.save
      render json: {message: 'You can now user your email and password to get token from our server.'}
    else
      render json: {message: @user.errors.full_messages}
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
