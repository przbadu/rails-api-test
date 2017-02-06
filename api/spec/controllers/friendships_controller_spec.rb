require 'rails_helper'

RSpec.describe FriendshipsController, type: :request do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }
  
  let(:friendship_params) {
    {friend_id: friend.id}
  }

  context '.Create' do
    it 'should be unauthorized request' do
      post '/friendships', params: {friendship: friendship_params}
      expect(response.status).to eq(401)
    end

    context '.Authorized' do
      it 'should require friend_id' do
        post '/friendships', params: {friendship: {fake: 'params'}},
          headers: authenticated_header(user)

        expect(last_response).to include_json(error: ["Friend can't be blank", "Friend must exist"])
      end
      
      it 'should create friendship' do
        post '/friendships', params: {friendship: friendship_params},
          headers: authenticated_header(user)

        expect(last_response).to include_json(success: 'Friend request sent')
        expect(Friendship.count).to eq(1)
        expect(Friendship.last.user_id).to eq(user.id)
        expect(Friendship.last.friend_id).to eq(friend.id)
        expect(Friendship.last.status).to eq("pending")
      end
    end
  end

  context '.Destroy' do
    it 'should be unauthorized access' do
      delete "/friendships/#{friend.id}"

      expect(response.status).to eq(401)
    end

    context '.Authorized' do
      it 'should destroy friendship' do
        post '/friendships', params: {friendship: friendship_params},
          headers: authenticated_header(user)

        delete "/friendships/#{friend.id}",
          headers: authenticated_header(user)

        expect(last_response).to include_json(success: 'Friend removed')
        expect(Friendship.count).to eq(0)
      end
    end
  end
end
