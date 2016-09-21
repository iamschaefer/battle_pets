require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'experience gains' do
    shared_examples 'increases experience by' do |exp_gain|
      it exp_gain.to_s do
        before_experience = @self.experience
        expect { @self.contest_complete! }.to change { @self.experience }
          .from(before_experience)
          .to(before_experience + exp_gain)
      end
    end

    shared_context 'when self was winner' do
      before :each do
        @contest = FactoryGirl.create(:pet_contest,
                                      challenger: @self,
                                      challenged: @opponent,
                                      winner: @self,
                                      workflow_state: :in_arena)
      end
    end

    shared_context 'when opponent was winner' do
      before :each do
        @contest = FactoryGirl.create(:pet_contest,
                                      challenger: @self,
                                      challenged: @opponent,
                                      winner: @opponent,
                                      workflow_state: :in_arena)
      end
    end

    describe '#contest_complete!' do
      context 'when young and less experienced than opponent' do
        before :each do
          @self = FactoryGirl.create(:pet, name: 'Pickles', experience: 100, workflow_state: :in_contest)
          @opponent = FactoryGirl.create(:pet, name: 'Izzy', experience: 120, workflow_state: :in_contest)
        end
        context 'when self won' do
          include_context 'when self was winner'
          it_behaves_like 'increases experience by', 22
        end
        context 'when other won' do
          include_context 'when opponent was winner'
          it_behaves_like 'increases experience by', 11
        end
      end
      context 'when much more experienced than opponent' do
        before :each do
          @self = FactoryGirl.create(:pet, name: 'Pickles', experience: 10_000, workflow_state: :in_contest)
          @opponent = FactoryGirl.create(:pet, name: 'Izzy', experience: 100, workflow_state: :in_contest)
        end
        context 'when self won' do
          include_context 'when self was winner'
          it_behaves_like 'increases experience by', 10
        end
        context 'when other won' do
          include_context 'when opponent was winner'
          it_behaves_like 'increases experience by', 5
        end
      end
      context 'when both are experienced' do
        before :each do
          @self = FactoryGirl.create(:pet, name: 'Pickles', experience: 100_000, workflow_state: :in_contest)
          @opponent = FactoryGirl.create(:pet, name: 'Izzy', experience: 100_000, workflow_state: :in_contest)
        end
        context 'when self won' do
          include_context 'when self was winner'
          it_behaves_like 'increases experience by', 4004
        end
        context 'when other won' do
          include_context 'when opponent was winner'
          it_behaves_like 'increases experience by', 2002
        end
      end
    end
  end
end
