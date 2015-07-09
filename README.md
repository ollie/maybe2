# Maybe2 [![Build Status](https://img.shields.io/travis/ollie/maybe2/master.svg)](https://travis-ci.org/ollie/maybe2) [![Code Climate](https://img.shields.io/codeclimate/github/ollie/maybe2.svg)](https://codeclimate.com/github/ollie/maybe2)

Wrap a value into a Maybe monad (or Optional type). Since monads are chainable
and every value is wrapped in one, things don't blow up with `NoMethodError`
on `nil`s.

Useful for retrieving something in deeply nested structures where `nil`s
could be produced along the way.

## Usage

```ruby
maybe = Maybe.new('Hello world').upcase.reverse
maybe.class  # => Maybe
maybe.unwrap # => 'Hello world'

maybe = Maybe.new(nil).upcase.reverse
maybe.class  # => Maybe
maybe.unwrap # => nil

maybe = Maybe.new('Hello world').make_nil.upcase.reverse
maybe.class  # => Maybe
maybe.unwrap # => nil
```

JSON example evaluation to a string:

```ruby
response = {
  data: {
    item: {
      name: 'Hello!'
    }
  }
}

Maybe.new(good_response)[:data][:item][:name].upcase.unwrap # => 'HELLO!'
```

JSON example evaluating to nil:

```ruby
response = {
  data: {}
}

Maybe.new(good_response)[:data][:item][:name].upcase.unwrap # => nil
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'maybe2'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install maybe2

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ollie/maybe2.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
