require "spec_helper"
require "support"

RSpec.describe SimpleState::Machine do
  let(:dsl_definition) do
    proc do
      state :pending, :outsourced, :printed, :matched, :dispatched, :cancelled

      transition :print,  from: [:pending, :outsourced], to: :printed
      transition :match,  from: :printed, to: :matched
      transition :ship,   from: :matched, to: :dispatched
      transition :cancel, from: [:pending, :outsourced, :printed, :matched], to: :cancelled
    end
  end

  describe "correctly transition between states" do
    describe "when unit is in pending state" do
      let(:unit)          { Unit.new(state: :pending) }
      let(:state_machine) { described_class.new(unit, :state, &dsl_definition) }

      it "allows to change to printed" do
        state_machine.print!

        expect(unit.state).to eq(:printed)
      end

      describe "when trying to transition to non-allowed state" do
        it "raises error for transition method" do
          expect { state_machine.match! }.to raise_error(SimpleState::TransitionError)
        end

        it "returns false for check method" do
          expect(state_machine.can_match?).to be_falsey
        end
      end

      describe "when transits to state which allow to change from multiple states" do
        before do
          unit.state = :matched
        end

        it "transits to cancel state" do
          state_machine.cancel!

          expect(unit.state).to eq(:cancelled)
        end

        it "raises error when changing to wrong state" do
          expect { state_machine.print! }.to raise_error(SimpleState::TransitionError)
        end
      end
    end
  end
end
