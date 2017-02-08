require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :first_name}
  it { should validate_presence_of :last_name}
  it { should validate_presence_of :password}
  it { should validate_presence_of :email}
  it { should validate_uniqueness_of(:email).case_insensitive}

  it { should have_many :friendships}
  it { should have_many :friends}
  it { should have_many :inverse_friendships}
  it { should have_many :inverse_friends}

  context '.Associations' do
    let(:user) {create(:user)}
    let(:friend1) {create(:user)}
    let(:friend2) {create(:user)}
    let(:friend3) {create(:user)}

    before do
    @friendship1 =  create(:friendship, user_id: user.id, friend_id: friend1.id, status: :pending)
    @friendship2 =  create(:friendship, user_id: friend2.id, friend_id: user.id, status: :accepted)
    @friendship3 =  create(:friendship, user_id: friend2.id, friend_id: friend3.id, status: :declined)
    @friendship4 = create(:friendship, user_id: user.id, friend_id: friend3.id, status: :accepted)
    end

    context '.friendships' do
      it { expect(user.friendships).to eq([@friendship1, @friendship4])}
      it { expect(friend1.friendships).to eq([])}
      it { expect(friend2.friendships).to eq([@friendship2, @friendship3])}
      it { expect(friend3.friendships).to eq([])}
    end

    context '.friends' do
      it { expect(user.friends).to eq([friend1, friend3])}
      it { expect(friend1.friends).to eq([])}
      it {expect(friend2.friends).to eq([user, friend3])}
      it {expect(friend3.friends).to eq([])}
    end

    context '.inverse_friendships' do
      it { expect(user.inverse_friendships).to eq([@friendship2])}
      it { expect(friend1.inverse_friendships).to eq([@friendship1])}
      it { expect(friend2.inverse_friendships).to eq([])}
      it { expect(friend3.inverse_friendships).to eq([@friendship3, @friendship4])}
    end

    context '.inverse_friends' do
      it { expect(user.inverse_friends).to eq([friend2])}
      it { expect(friend1.inverse_friends).to eq([user])}
      it { expect(friend2.inverse_friends).to eq([])}
      it { expect(friend3.inverse_friends).to eq([user, friend2])}
    end
  end
end
