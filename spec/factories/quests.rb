FactoryGirl.define do
  factory :quest do
    user nil
    description "MyText"
    goal 1
    reward "MyText"
    complete false
  end
end
