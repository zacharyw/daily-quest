FactoryGirl.define do
  factory :quest, aliases: [:valid_quest] do
    user {build :user }
    description "The Golden Fleece"
    goal 1
    reward "Money"
    complete false

    factory :completed_quest, class: Quest do
      complete true
    end

    factory :active_quest, class: Quest do
      complete false
    end
  end
end
