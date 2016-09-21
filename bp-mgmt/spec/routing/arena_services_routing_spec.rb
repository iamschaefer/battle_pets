require 'rails_helper'

RSpec.describe ArenaServicesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/arena_services').to route_to('arena_services#index')
    end

    it 'routes to #new' do
      expect(get: '/arena_services/new').to route_to('arena_services#new')
    end

    it 'routes to #show' do
      expect(get: '/arena_services/1').to route_to('arena_services#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/arena_services/1/edit').to route_to('arena_services#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/arena_services').to route_to('arena_services#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/arena_services/1').to route_to('arena_services#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/arena_services/1').to route_to('arena_services#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/arena_services/1').to route_to('arena_services#destroy', id: '1')
    end
  end
end
