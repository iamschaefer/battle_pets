require 'rails_helper'

RSpec.describe PetContestsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/pet_contests').to route_to('pet_contests#index')
    end

    it 'routes to #new' do
      expect(get: '/pet_contests/new').to route_to('pet_contests#new')
    end

    it 'routes to #show' do
      expect(get: '/pet_contests/1').to route_to('pet_contests#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/pet_contests/1/edit').to route_to('pet_contests#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/pet_contests').to route_to('pet_contests#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/pet_contests/1').to route_to('pet_contests#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/pet_contests/1').to route_to('pet_contests#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/pet_contests/1').to route_to('pet_contests#destroy', id: '1')
    end
  end
end
