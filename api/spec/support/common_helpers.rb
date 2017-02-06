def last_response
  JSON.parse(response.body)
end

def last_status
  response.status
end

def decode_jwt(key_s)
  JWT.decode(key_s, Rails.application.secrets.secret_key_base, true, {algorithm: 'HS256'})
end

def authenticated_header(user)
  token = Knock::AuthToken.new(payload: {sub: user.id}).token
  {'Authorization': "Bearer #{token}"}
end
