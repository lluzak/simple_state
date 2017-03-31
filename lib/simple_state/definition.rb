class SimpleState::Definition
  def self.define(&block)
    new(&block).definition
  end

  attr_reader :definition

  def initialize(&block)
    @definition = { transitions: {} }

    instance_exec(&block)
  end

  private

  def transition(name, to:, from:)
    @definition[:transitions][name] = { from: [*from], to: to }
  end

  def state(*states)
    @definition[:states] = states
  end
end
