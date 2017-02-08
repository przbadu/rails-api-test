class UsersController < ApplicationController
  before_action :authenticate_user, except: :create
  
  def show
    render json: current_user
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      render json: {message: 'You can now user your email and password to get token from our server.'}, status: :created
    else
      render json: {message: @user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
