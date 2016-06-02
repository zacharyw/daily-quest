require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#active_quests' do
    let(:user) { build(:user) }
    subject { user.active_quests.to_a }

    context "when first created" do
      it { is_expected.to be_empty }
    end

    context "all quests complete" do
      before do
        build(:completed_quest, user: user)
      end

      it { is_expected.to be_empty }
    end

    context "some active, some complete" do
      before do
        create(:completed_quest, user: user)
        @active_quest = create(:active_quest, user: user)
      end

      it "has one quest" do
        expect(subject.size).to eq 1
      end

      it { is_expected.to eq [@active_quest] }
    end

    context "all quests active" do
      before do
        @active_quest = create(:active_quest, user: user)
      end

      it "has one quest" do
        expect(subject.size).to eq 1
      end

      it { is_expected.to eq [@active_quest] }
    end
  end
end
