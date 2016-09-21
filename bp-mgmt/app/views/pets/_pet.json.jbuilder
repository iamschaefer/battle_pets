json.extract! pet, :id, :user_id, :name, :pet_type, :workflow_state, :strength, :wit, :senses, :agility,
              :experience, :created_at, :updated_at
json.url pet_url(pet, format: :json)
