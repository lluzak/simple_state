module SimpleState
  class Machine
    def initialize(object, state_attribute = :state, definition = nil, &block)
      @object          = object
      @state_attribute = state_attribute
      @definition      = definition || SimpleState::Definition.define(&block)

      define_trasition_methods
    end

    private

    def transitions
      @definition[:transitions]
    end

    def define_trasition_methods
      transitions.each { |name, options| define_transition_method(name, options) }
    end

    def define_transition_method(name, from:, to:)
      define_singleton_method(:"can_#{name}?") do
        current_state = @object.public_send(@state_attribute)
        from.include?(current_state.to_sym)
      end

      define_singleton_method(:"#{name}!") do
        unless public_send(:"can_#{name}?")
          raise TransitionError, "Unable to transition from #{@object.public_send(@state_attribute)} to #{to}"
        end

        @object.public_send(:"#{@state_attribute}=", to)
      end
    end
  end
end
