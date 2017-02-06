def json(body)
  JSON.parse(body)
end

def decode_jwt(key_s)
  JWT.decode(key_s, Rails.application.secrets.secret_key_base, true, {algorithm: 'HS256'})
end
