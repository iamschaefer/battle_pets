require 'rails_helper'

RSpec.describe 'PetContests', type: :request do
  # TODO: add in contest types here, like pet types

  describe 'GET /pet_contests' do
    it 'works! (now write some real specs)' do
      get pet_contests_path
      expect(response).to have_http_status(200)
    end
  end
end
