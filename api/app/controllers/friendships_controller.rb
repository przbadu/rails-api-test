class FriendshipsController < ApplicationController
  before_action :authenticate_user

  def create
    @friendship = current_user.friendships.new(friendship_params)
    @friendship.status = :pending

    if @friendship.save
      render json: {success: 'Friend request sent'}, status: :created
    else
      render json: {error: @friendship.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    @friendship = current_user.friendships.find_by(friend_id: params[:id])
    @friendship.destroy

    render json: {success: "Friend removed"}, status: :deleted
  end

  private

  def friendship_params
    params.require(:friendship).permit(:friend_id)
  end
end
