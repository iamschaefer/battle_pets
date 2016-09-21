require 'rails_helper'

RSpec.describe PetContest, type: :model do
  context 'when making new contest' do
    before :each do
      @challenger = FactoryGirl.create(:pet, name: 'Pickles')
      @challenged = FactoryGirl.create(:pet, name: 'Sparky')
      allow(@challenged).to receive(:challenged!)
      @contest = PetContest.create!(challenger: @challenger, challenged: @challenged, contest_type: 'fight')
    end
    it 'sends challenged! message to challenged pet' do
      expect(@challenged).to have_received(:challenged!)
    end
    context 'when initializing contest again' do
      before :each do
        PetContest.find_by_id(@contest.id)
      end
      it 'does not send challenged! to challenged pet' do
        expect(@challenged).to have_received(:challenged!).exactly(1).times
      end
    end
  end

  context 'when in challenged state' do
    describe '#accept!' do
      before :each do
        @arena_service = double(ArenaService)
        allow(ArenaServiceLocator).to receive(:locate).and_return(@arena_service)
        @contest = FactoryGirl.create(:pet_contest, workflow_state: :challenged)
      end
      context 'when new contest request succeeds' do
        before :each do
          allow(@arena_service).to receive(:new_contest!).and_return(true)
          @contest.accept!
        end
        it 'sends new contest request to an arena service' do
          expect(@arena_service).to have_received(:new_contest!).with(@contest)
        end
        it 'transitions to in_arena' do
          expect(@contest.current_state).to eq(:in_arena)
        end
      end
      context 'when new contest request fails' do
        before :each do
          allow(@contest.challenger).to receive(:contest_cancelled!)
          allow(@contest.challenged).to receive(:contest_cancelled!)
          allow(@arena_service).to receive(:new_contest!).and_return(false)
          @contest.accept!
        end
        it 'transitions to cancelled' do
          expect(@contest.current_state).to eq(:cancelled)
        end
        it 'tells challenger that contest was cancelled' do
          expect(@contest.challenger).to have_received(:contest_cancelled!)
        end
        it 'tells challenge that contest was cancelled' do
          expect(@contest.challenged).to have_received(:contest_cancelled!)
        end
      end
    end
  end

  context 'when in in_arena state' do
    before :each do
      @contest = FactoryGirl.create(:pet_contest, workflow_state: :in_arena)
      allow(@contest.challenger).to receive(:contest_complete!)
      allow(@contest.challenged).to receive(:contest_complete!)
    end
    describe '#complete' do
      before :each do
        @contest.complete!(@contest.challenger.id)
      end
      it 'sends #contest_complete! to challenger' do
        expect(@contest.challenger).to have_received(:contest_complete!)
      end
      it 'sends #contest_complete! to challenger' do
        expect(@contest.challenged).to have_received(:contest_complete!)
      end
    end
  end
end
