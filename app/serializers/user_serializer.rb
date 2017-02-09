class UserSerializer < ApplicationSerializer
  attributes :id, :email, :first_name, :last_name
  has_many :friends, if: :current_user
  has_many :inverse_friends, if: :current_user
end
