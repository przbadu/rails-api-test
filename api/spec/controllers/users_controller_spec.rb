require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user_params) {
    {email: 'user@example.com', password: 'password', first_name: 'user', last_name: 'test'}
  }
  
  context '#sign_up' do
    it 'should raise strong params error' do
      expect {post :create}.to raise_error(ActionController::ParameterMissing)
    end

    it 'email is required' do
      post :create, params: {user: user_params.except(:email)}
      expect(json(response.body)).to eq({"message" => ["Email can't be blank"]})
    end

    it 'email should be unique' do
      create(:user, user_params)
      post :create, params: {user: user_params}

      expect(json(response.body)).to eq({"message" => ["Email has already been taken"]})
    end

    it 'password is required' do
      post :create, params: {user: user_params.except(:password)}
      expect(json(response.body)).to eq({"message" => ["Password can't be blank"]})
    end

    it 'first name is required' do
      post :create, params: {user: user_params.except(:first_name)}
      expect(json(response.body)).to eq("message" => ["First name can't be blank"])
    end

    
    it 'last name is required' do
      post :create, params: {user: user_params.except(:last_name)}
      expect(json(response.body)).to eq("message" => ["Last name can't be blank"])
    end

    it 'should create new user' do
      post :create, params: {user: user_params}
      
      expect(json(response.body)).to eq("message" => "You can now user your email and password to get token from our server.")
      expect(User.count).to eq(1)
      expect(User.last.email).to eq(user_params[:email])
    end
  end
end
