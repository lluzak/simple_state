# SimpleState [![Build Status](https://travis-ci.org/lluzak/simple_state.svg?branch=master)](https://travis-ci.org/lluzak/simple_state)

Dead simple state machine for modular usage.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_state'
```

## Usage

``` ruby
class Unit
  def initialize(state:)
    @state = state
  end

  attr_accessor :state
end

unit = Unit.new(state: :pending)

state_machine = SimpleState::Machine.new(unit, :state) do
  state :pending, :outsourced, :printed, :matched, :dispatched, :cancelled

  transition :print, from: [:pending, :outsourced], to: :printed
  transition :match, from: :printed, to: :matched
  transition :ship, from: :matched, to: :dispatched
  transition :cancel, from: [:pending, :outsourced, :printed, :matched], to: :cancelled
end

state_machine.can_print?
state_machine.print!

state_machine.match!
state_machine.can_cancel?

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lluzak/simple_state. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
