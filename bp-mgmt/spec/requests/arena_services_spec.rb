require 'rails_helper'

RSpec.describe 'ArenaServices', type: :request do
  describe 'GET /arena_services' do
    it 'works! (now write some real specs)' do
      get arena_services_path
      expect(response).to have_http_status(200)
    end
  end
end
