class UserSerializer < ApplicationSerializer
  attributes :id, :email, :first_name, :last_name
  has_many :friends
  has_many :inverse_friends
end
