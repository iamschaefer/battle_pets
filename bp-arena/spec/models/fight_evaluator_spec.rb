require 'rails_helper'

RSpec.describe FightEvaluator, type: :model do
  describe '#winner' do
    context 'when competitor 1 has more strength' do
      before :each do
        @competitor1 = { 'strength' => 100, 'experience' => 100 }
        @competitor2 = { 'strength' => 99, 'experience' => 100 }
        @evaluator = FightEvaluator.new(@competitor1, @competitor2)
      end
      it 'returns competitor 1' do
        expect(@evaluator.winner).to eq(@competitor1)
      end
    end
    context 'when competitor 2 has more strength' do
      before :each do
        @competitor1 = { 'strength' => 100, 'experience' => 100 }
        @competitor2 = { 'strength' => 990, 'experience' => 100 }
        @evaluator = FightEvaluator.new(@competitor1, @competitor2)
      end
      it 'returns competitor 1' do
        expect(@evaluator.winner).to eq(@competitor2)
      end
    end
    context 'when competitors have equal strength' do
      before :each do
        @competitor1 = { 'strength' => 100, 'experience' => 100 }
        @competitor2 = { 'strength' => 100, 'experience' => 101 }
        @evaluator = FightEvaluator.new(@competitor1, @competitor2)
      end
      it 'returns competitor with more experience' do
        expect(@evaluator.winner).to eq(@competitor2)
      end
    end

    context 'when competitors have equal strength and experience' do
      before :each do
        @competitor1 = { 'strength' => 100, 'experience' => 100 }
        @competitor2 = { 'strength' => 100, 'experience' => 100 }
        @evaluator = FightEvaluator.new(@competitor1, @competitor2)
      end
      context 'when RNG returns 0' do
        before :each do
          allow(SecureRandom).to receive(:random_number).with(2).and_return(0)
        end
        it 'returns competitor1' do
          expect(@evaluator.winner).to eq(@competitor1)
        end
      end
      context 'when RNG returns 1' do
        before :each do
          allow(SecureRandom).to receive(:random_number).with(2).and_return(1)
        end
        it 'returns competitor2' do
          expect(@evaluator.winner).to eq(@competitor2)
        end
      end
    end
  end
end
