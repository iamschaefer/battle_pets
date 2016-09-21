FactoryGirl.define do
  factory :pet do
    name 'Fluffy'
    association :user, strategy: :build
    strength 200
    agility 180
    wit 219
    senses 12
    pet_type 'rock'
    experience 20
  end

  # The attributes for a new pet. Users should not be able to specify other attributes
  factory :new_pet, class: Pet do
    name 'Squirtle'
    pet_type 'water'
  end
end
