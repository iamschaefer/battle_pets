require 'rails_helper'

RSpec.describe ChessEvaluator, type: :model do
  describe '#winner' do
    context 'when competitor 1 has more wit' do
      before :each do
        @competitor1 = { 'wit' => 100, 'experience' => 100 }
        @competitor2 = { 'wit' => 99, 'experience' => 100 }
        @evaluator = ChessEvaluator.new(@competitor1, @competitor2)
      end
      it 'returns competitor 1' do
        expect(@evaluator.winner).to eq(@competitor1)
      end
    end
    context 'when competitor 2 has more wit' do
      before :each do
        @competitor1 = { 'wit' => 100, 'experience' => 100 }
        @competitor2 = { 'wit' => 990, 'experience' => 100 }
        @evaluator = ChessEvaluator.new(@competitor1, @competitor2)
      end
      it 'returns competitor 1' do
        expect(@evaluator.winner).to eq(@competitor2)
      end
    end
    context 'when competitors have equal wit' do
      before :each do
        @competitor1 = { 'wit' => 100, 'experience' => 100 }
        @competitor2 = { 'wit' => 100, 'experience' => 101 }
        @evaluator = ChessEvaluator.new(@competitor1, @competitor2)
      end
      it 'returns competitor with more experience' do
        expect(@evaluator.winner).to eq(@competitor2)
      end
    end

    context 'when competitors have equal wit and experience' do
      before :each do
        @competitor1 = { 'wit' => 100, 'experience' => 100 }
        @competitor2 = { 'wit' => 100, 'experience' => 100 }
        @evaluator = ChessEvaluator.new(@competitor1, @competitor2)
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
