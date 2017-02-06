require "rails_helper"

RSpec.describe UserTokenController do
  context '.user_token' do
    let(:user) { create(:user, email: 'user@example.com', password: 'password', first_name: 'test', last_name: 'user')}

    it 'should require auth params' do
      expect {post :create}.to raise_error(ActionController::ParameterMissing)
    end

    it 'should be invalid user' do
      post :create, params: {auth: {email: 'fake@example.com', password: 'fake'}}
      expect(response.status).to eq(404)
    end

    it 'should not allow with invalid password' do
      post :create, params: {auth: {email: 'user@example.com', password: 'fake'}}
      expect(response.status).to eq(404)
    end

    it 'should return JWT' do
      post :create, params: {auth: {email: user.email, password: user.password}}
      header, payload, secret = json(response.body)["jwt"].split('.')

      expect(header).not_to be_nil
      expect(payload).not_to be_nil
      expect(payload).not_to be_nil
    end
  end
end
