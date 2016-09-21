require 'rails_helper'

RSpec.describe ArenaService, type: :model do
  describe '#new_contest!' do
    before :each do
      @contest = FactoryGirl.create(:pet_contest)
      @arena_service = FactoryGirl.build_stubbed(:arena_service)
    end
    it 'posts to the service' do
      url = "http://#{@arena_service.address}:#{@arena_service.port}/contest_evaluations/"
      body = { contest_id: @contest.id.to_s, # TODO: figure out why this has to be a string
               challenger: @contest.challenger.to_json,
               challenged: @contest.challenged.to_json,
               contest_type: @contest.contest_type }
      stub = stub_request(:post, url).with(body: body).to_return(status: 200)
      @arena_service.new_contest!(@contest)
      expect(stub).to have_been_requested.once
    end
  end
end
