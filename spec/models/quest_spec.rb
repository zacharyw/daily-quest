require 'rails_helper'

RSpec.describe Quest, type: :model do
  let(:quest) { create(:quest) }

  describe '#chain' do
    subject {
      quest.chain
    }

    context 'no completions' do
      it { is_expected.to eq 0}
    end

    context 'all completions more than 24 hours ago' do
      before do
        create(:completion, quest: quest, created_at: 25.hours.ago, date_completed: 25.hours.ago)
      end

      it "has one total completion" do
        expect(quest.completions.size).to eq 1
      end

      it { is_expected.to eq 0 }
    end

    context 'one completion in last 24 hours' do
      before do
        create(:completion, quest: quest, created_at: 1.hours.ago, date_completed: 1.hours.ago)
      end

      it { is_expected.to eq 1 }
    end

    context 'completions with 24 hour break between' do
      before do
        create(:completion, quest: quest, created_at: 3.days.ago, date_completed: 3.days.ago)
        create(:completion, quest: quest, created_at: 23.hours.ago, date_completed: 23.hours.ago)
      end

      it "has two total completions" do
        expect(quest.completions.size).to eq 2
      end

      it { is_expected.to eq 1 }
    end

    context 'several completions in a row' do
      let(:days) { 0..10 }

      before do
        days.each do |n|
          date = n.days.ago
          create(:completion, quest: quest, created_at: date, date_completed: date)
        end
      end

      it { is_expected.to eq days.size}
    end
  end

  describe '#longest_chain' do
    subject {
      quest.longest_chain
    }

    context 'no completions' do
      it { is_expected.to eq 0 }
    end

    context 'no connected chains' do
      before do
        date = 3.days.ago
        create(:completion, quest: quest, created_at: date, date_completed: date)
        date = 1.days.ago
        create(:completion, quest: quest, created_at: date, date_completed: date)
      end

      it { is_expected.to eq 1 }
    end

    context 'two chains, one is longer' do
      let(:longest) { (5..10) }

      before do
        (1..3).each do |n|
          date = n.days.ago
          create(:completion, quest: quest, created_at: date, date_completed: date)
        end

        longest.each do |n|
          date = n.days.ago
          create(:completion, quest: quest, created_at: date, date_completed: date)
        end
      end

      it { is_expected.to eq longest.size }
    end

    context 'current chain is longest' do
      let(:longest) { (0..10) }

      before do
        longest.each do |n|
          date = n.days.ago
          create(:completion, quest: quest, created_at: date, date_completed: date)
        end

        it { is_expected.to eq longest.size }
      end
    end
  end

  describe '#toggle_completions' do
    subject { quest.toggle_completion }

    context 'no completion for today' do
      it { is_expected.to be true }

      it 'should create one' do
        expect(quest.completions.size).to eq 0
        subject
        expect(quest.completions.size).to eq 1
      end
    end

    context 'completion exists today' do
      before do
        create(:completion, quest: quest)
        create(:completion, quest: quest, created_at: 3.days.ago, date_completed: 3.days.ago)
      end

      it { is_expected.to be false }

      it 'should destroy it' do
        expect(quest.completions.size).to eq 2
        subject
        expect(quest.completions.size).to eq 1
      end
    end
  end

  describe '#complete_today?' do
    subject { quest.complete_today? }

    context 'no completion today' do
      it { is_expected.to be false }
    end

    context 'completion today' do
      before { create(:completion, quest: quest) }

      it { is_expected.to be true }
    end
  end
end
