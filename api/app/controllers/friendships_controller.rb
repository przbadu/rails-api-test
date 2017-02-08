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

  def update
    case params[:status]
    when 'accept'
      current_user.accept_friend_request!(params[:id])
      responsee = {success: "Friend request accepted"}
    when 'decline'
      current_user.decline_friend_request!(params[:id])
      responsee = {success: "Friend request declined"}
    else
      responsee = {error: "Invalid request"}
    end

    render json: responsee
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
