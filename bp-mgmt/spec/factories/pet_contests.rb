FactoryGirl.define do
  factory :pet_contest do
    association :challenger, factory: :pet
    association :challenged, factory: :pet
    winner nil
    contest_type 'fight'
    workflow_state :new
  end
end
