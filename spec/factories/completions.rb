FactoryGirl.define do
  factory :completion do
    quest nil
    created_at DateTime.now
    date_completed Date.today
  end
end
