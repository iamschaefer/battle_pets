require 'rails_helper'

RSpec.describe 'Pets', type: :request do
  before :each do
    @user = FactoryGirl.create(:user)
  end

  describe 'POST /users/:id/pets' do
    context 'with a valid user' do
      context 'pet type "rock"' do
        it 'returns a json pet' do
          params = { pet: FactoryGirl.attributes_for(:new_pet) }
          expect { post(user_pets_path(user_id: @user.id), params: params) }.to change { Pet.all.size }.by(1)
        end
      end
    end
  end

  describe 'GET /pets.json' do
    before :each do
      FactoryGirl.create(:pet, user: @user, name: 'First', experience: 1000)
      FactoryGirl.create(:pet, user: @user, name: 'Fourth', experience: 700)
      FactoryGirl.create(:pet, user: @user, name: 'Third', experience: 800)
      FactoryGirl.create(:pet, user: @user, name: 'Second', experience: 900)
    end
    it 'returns json of pets, ordered by experience', :aggregate_failures do
      get pets_path format: :json
      leader_board = JSON.parse(response.body)
      expect(leader_board.first['name']).to eq('First')
      expect(leader_board.second['name']).to eq('Second')
      expect(leader_board.third['name']).to eq('Third')
      expect(leader_board.fourth['name']).to eq('Fourth')
    end
  end

  describe 'GET /pets/types.json' do
    it 'returns the valid pet types' do
      get '/pets/types.json'
      types = JSON.parse(response.body)
      expect(types).to match(%w(water wind fire earth))
    end
  end
end
