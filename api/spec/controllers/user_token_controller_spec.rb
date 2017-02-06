require "rails_helper"

RSpec.describe UserTokenController do
  before { Timecop.freeze(2017, 1, 1, 10, 5, 0)}
  after { Timecop.return}
  
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

    context 'check valid response' do
      before do
        post :create, params: {auth: {email: user.email, password: user.password}}
        @decoded = decode_jwt last_response['jwt']
      end

      it 'should return JWT' do
        expect(last_response).to include_json(jwt: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0ODMzNTE1MDAsInN1YiI6MX0.fPrB6fxRFhiTrut6Fvz5dwXL6Dmp7bOmJ9kA3Jhd7Io')
      end

      it 'should have exp and sub payload' do
        expect(@decoded).to eq([{"exp"=>1483351500, "sub"=>user.id}, {"typ"=>"JWT", "alg"=>"HS256"}])
      end
    end
  end
end
