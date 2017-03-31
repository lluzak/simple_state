require "spec_helper"

RSpec.describe SimpleState::Definition do
  describe "#build_state_machine" do
    it "transforms DSL into configuration object" do
      expected = {
        states: [:pending, :outsourced, :printed, :matched, :dispatched, :cancelled],
        transitions: {
          print:  { from: [:pending, :outsourced], to: :printed },
          match:  { from: [:printed], to: :matched },
          ship:   { from: [:matched], to: :dispatched },
          cancel: { from: [:pending, :outsourced, :printed, :matched], to: :cancelled }
        }
      }

      definition = described_class.define do
        state :pending, :outsourced, :printed, :matched, :dispatched, :cancelled

        transition :print, from: [:pending, :outsourced], to: :printed
        transition :match, from: :printed, to: :matched
        transition :ship, from: :matched, to: :dispatched
        transition :cancel, from: [:pending, :outsourced, :printed, :matched], to: :cancelled
      end

      expect(definition).to eq(expected)
    end
  end
end
