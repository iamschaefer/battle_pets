require 'spec_helper'

RSpec.describe RaceEvaluator, type: :model do
  describe '#winner' do
    context 'when competitor 1 has more agility' do
      before :each do
        @competitor1 = { 'agility' => 100, 'experience' => 100 }
        @competitor2 = { 'agility' => 99, 'experience' => 100 }
        @evaluator = RaceEvaluator.new(@competitor1, @competitor2)
      end
      it 'returns competitor 1' do
        expect(@evaluator.winner).to eq(@competitor1)
      end
    end
    context 'when competitor 2 has more agility' do
      before :each do
        @competitor1 = { 'agility' => 100, 'experience' => 100 }
        @competitor2 = { 'agility' => 990, 'experience' => 100 }
        @evaluator = RaceEvaluator.new(@competitor1, @competitor2)
      end
      it 'returns competitor 1' do
        expect(@evaluator.winner).to eq(@competitor2)
      end
    end
    context 'when competitors have equal agility' do
      before :each do
        @competitor1 = { 'agility' => 100, 'experience' => 100 }
        @competitor2 = { 'agility' => 100, 'experience' => 101 }
        @evaluator = RaceEvaluator.new(@competitor1, @competitor2)
      end
      it 'returns competitor with more experience' do
        expect(@evaluator.winner).to eq(@competitor2)
      end
    end

    context 'when competitors have equal agility and experience' do
      before :each do
        @competitor1 = { 'agility' => 100, 'experience' => 100 }
        @competitor2 = { 'agility' => 100, 'experience' => 100 }
        @evaluator = RaceEvaluator.new(@competitor1, @competitor2)
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
