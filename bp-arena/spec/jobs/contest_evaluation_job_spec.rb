require 'rails_helper'

RSpec.describe ContestEvaluationJob do
  def pet_factory(opts = {})
    { 'id' => 1,
      'agility' => 100,
      'strength' => 100,
      'wit' => 100,
      'senses' => 100,
      'experience' => 100 }.merge(opts)
  end

  describe 'contest evaluation' do
    context 'with stubbed evaluator' do
      before :each do
        @pet1 = pet_factory('id' => 1)
        @pet2 = pet_factory('id' => 2)

        @contest = FactoryGirl.build_stubbed(:contest_evaluation, challenger: @pet1.to_json, challenged: @pet2.to_json)
        allow_any_instance_of(ContestEvaluationJob).to receive(:sleep)
        evaluator = double('Evaluator')
        allow(evaluator).to receive(:winner).and_return(@pet1)
        allow(EvaluatorFactory).to receive(:new_for_contest_type).with(@contest.contest_type, @pet1, @pet2)
          .and_return(evaluator)
      end
      describe '#perform' do
        before :each do
          url = "http://#{@contest.callback_host}:3000/pet_contests/#{@contest.contest_id}/complete.json"
          @stub = stub_request(:post, url).with(body: { winner_id: '1' })
        end
        it 'posts winner_id to correct callback url' do
          ContestEvaluationJob.perform_now(@contest)
          expect(@stub).to have_been_requested.once
        end
      end
    end
  end
end
