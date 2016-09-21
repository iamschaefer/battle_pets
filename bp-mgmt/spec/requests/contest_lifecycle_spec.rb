require 'rails_helper'

##
# This is an intergration test for the lifecycle of a pet contest to make sure we can follow the workflow generally.
RSpec.describe 'Pet contest lifecycle', type: :request do
  before :each do
    user = FactoryGirl.create(:user)
    @pet1 = FactoryGirl.create(:pet, user: user, name: 'Ploofy')
    @pet2 = FactoryGirl.create(:pet, user: user, name: 'Loller')
  end
  context 'when user creates a new contest' do
    it 'has contest that is ready to accept' do
      params = { pet_contest: { contest_type: 'fight',
                                challenger_id: @pet1.id,
                                challenged_id: @pet2.id } }
      post('/pet_contests', params: params)
      expect(PetContest.last.current_state).to eq(:challenged)
    end
  end

  context 'when user accepts a contest' do
    before :each do
      @contest = FactoryGirl.create(:pet_contest,
                                    challenger: @pet1,
                                    challenged: @pet2,
                                    workflow_state: :challenged)
      @arena = FactoryGirl.create(:arena_service, address: '127.0.0.1', port: '3001')
    end
    it 'sends a proper request to the arena service' do
      # Pets will be set to 'in_arena' by the time this request is sent
      challenged = @contest.challenged.attributes.merge(workflow_state: :in_contest)
      challenger = @contest.challenger.attributes.merge(workflow_state: :in_contest)
      stub_request(:post, "http://#{@arena.address}:#{@arena.port}/contest_evaluations/")
      post("/pet_contests/#{@contest.id}/accept")

      # Note that the block with `do ... end` instead of curly brackets won't work!
      # Why? See this comment https://github.com/bblimke/webmock/issues/174#issuecomment-34908908
      expect(a_request(:post, "http://#{@arena.address}:#{@arena.port}/contest_evaluations/")
                 .with do |req|
               body_hash = Rack::Utils.parse_nested_query(req.body)
               body_hash['challenged'] == challenged.to_json &&
                   body_hash['challenger'] == challenger.to_json &&
                   body_hash['contest_type'] == @contest.contest_type &&
                   body_hash['contest_id'] == @contest.id.to_s
             end).to have_been_made.once
    end
  end

  context 'when service reports a complete contest' do
    before :each do
      @pet1.contesting!
      @pet2.contesting!
      @contest = FactoryGirl.create(:pet_contest,
                                    challenger: @pet1,
                                    challenged: @pet2,
                                    workflow_state: :in_arena)
    end
    it 'sets contest state to complete and awards pets experience', :aggregate_failures do
      before_exp1 = @pet1.experience
      before_exp2 = @pet2.experience
      post("/pet_contests/#{@contest.id}/complete.json", params: { 'winner_id' => @pet1.id })
      @pet1.reload
      @pet2.reload
      @contest.reload
      expect(@pet1.experience).to be > before_exp1
      expect(@pet2.experience).to be > before_exp2
      expect(@contest.workflow_state).to eq('completed')
    end
  end
end
