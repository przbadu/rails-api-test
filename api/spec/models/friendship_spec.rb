require 'rails_helper'

RSpec.describe Friendship, type: :model do
  it { should validate_presence_of :user_id}
  it { should validate_presence_of :friend_id}

  it { should define_enum_for(:status).with([:pending,
                                             :accepted,
                                             :declined])}

  it { should belong_to :user}
  it { should belong_to :friend}
end
