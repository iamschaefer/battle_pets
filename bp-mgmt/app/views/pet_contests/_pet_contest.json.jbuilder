json.extract! pet_contest, :id, :contest_type, :workflow_state, :challenger_id, :challenged_id, :winner_id, :created_at,
              :updated_at
json.url pet_contest_url(pet_contest, format: :json)
