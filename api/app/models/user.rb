class User < ApplicationRecord
  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false}

  has_many :friendships
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  def accept_friend_request!(friend_id)
    friendship = self.inverse_friendships.find_by(user_id: friend_id)
    friendship.accepted! unless friendship.blank?
  end

  def decline_friend_request!(friend_id)
    friendship = self.inverse_friendships.find_by(user_id: friend_id)
    friendship.declined! unless friendship.blank?
  end
end
