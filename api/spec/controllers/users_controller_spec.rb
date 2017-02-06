require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let(:user_params) {
    {email: 'user@example.com',
     password: 'password',
     first_name: 'user',
     last_name: 'test'}
  }
  
  let(:user) {create(:user,
                     first_name: 'test',
                     last_name: 'user',
                     email: 'test@example.com',
                     password: 'password')}
  
  
  context '#sign_up' do
    it 'should raise strong params error' do
      expect {post users_path}.to raise_error(ActionController::ParameterMissing)
    end

    it 'email is required' do
      post users_path, params: {user: user_params.except(:email)}
      expect(last_response).to include_json({message: ["Email can't be blank"]})
    end

    it 'email should be unique' do
      create(:user, user_params)
      post users_path, params: {user: user_params}

      expect(last_response).to include_json({message: ["Email has already been taken"]})
    end

    it 'password is required' do
      post users_path, params: {user: user_params.except(:password)}
      expect(last_response).to include_json({message: ["Password can't be blank"]})
    end

    it 'first name is required' do
      post users_path, params: {user: user_params.except(:first_name)}
      expect(last_response).to include_json(message: ["First name can't be blank"])
    end

    
    it 'last name is required' do
      post users_path, params: {user: user_params.except(:last_name)}
      expect(last_response).to include_json(message: ["Last name can't be blank"])
    end

    it 'should create new user' do
      post users_path, params: {user: user_params}
      
      expect(last_response).to include_json(message: "You can now user your email and password to get token from our server.")
      expect(User.count).to eq(1)
      expect(User.last.email).to eq(user_params[:email])
    end
  end

  context "#index" do
    it 'should be unauthorized without jwtoken' do
      get users_path
      expect(response.status).to eq(401)
    end

    context '.authorized' do
      
      it 'should return empty array' do
        @john = create(:user, first_name: 'John')
        @gary = create(:user, first_name: 'Gary')
        get users_path, headers: authenticated_header(user)
        
        expect(last_response).to include_json([UserSerializer.new(@john).as_json,
                                               UserSerializer.new(@gary).as_json,
                                               UserSerializer.new(user).as_json])
      end
    end
  end

  context '#Show' do
    it 'should be unauthorized without jwt token' do
      get "/users/#{user.id}"
      expect(response.status).to eq(401)
    end

    context '.authorized' do
      it 'should return user1' do
        user1 = create(:user)
        get "/users/#{user1.id}", headers: authenticated_header(user)

        expect(last_response).to include_json(UserSerializer.new(user1).as_json)
      end

      it 'should return user' do
        get "/users/#{user.id}", headers: authenticated_header(user)
        expect(last_response).to include_json(UserSerializer.new(user).as_json)
      end
    end
  end
end
