FactoryGirl.define do
  factory :contest_evaluation, class: ContestEvaluation do
    contest_id 7
    contest_type 'fight'
    callback_host '127.0.0.1'
  end
end
