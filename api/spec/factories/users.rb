FactoryGirl.define do
  factory :user do
    first_name "Test"
    last_name "User"
    sequence(:email) { |i| "testuser#{i}@gmail.com" }
    password_digest "$3cr3t"
  end
end
