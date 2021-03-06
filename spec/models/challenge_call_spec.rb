require 'rails_helper'

RSpec.describe ChallengeCall, type: :model do
  describe '#call_closed?' do
    describe 'open' do
      let(:call) { build_stubbed(:challenge_call, closing_date: 2.weeks.since) }

      it { expect(call.call_closed?).to be false }
    end

    describe 'closed' do
      let(:call) { build_stubbed(:challenge_call, closing_date: 2.weeks.ago) }

      it { expect(call.call_closed?).to be true }
    end

    describe 'nil' do
      let(:call) { build_stubbed(:challenge_call, closing_date: nil) }

      it { expect(call.call_closed?).to be false }
    end
  end
end
