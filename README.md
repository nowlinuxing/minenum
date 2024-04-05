# Minenum

Minenum is a gem that enhances Ruby objects by adding enum functionality and returning enum objects as return values. Enums simplify representing states or types within a specific range of values and can be returned directly from methods.

Features:

* Return enum objects directly from methods, enabling clearer and more expressive code.
* Simplify code by encapsulating valid value ranges within enums.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add minenum

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install minenum

## Usage

```ruby
class Shirt
  include Minenum::Model

  enum :size, { small: 1, medium: 2, large: 3 }
end
```

```ruby
shirt = Shirt.new
shirt.size = 1
shirt.size.name #=> :small
shirt.size.small? #=> true

# You can also set the name
shirt.size = :medium
shirt.size.name #=> :medium
shirt.size.medium? #=> true
```

```ruby
# You can get the enum values
Shirt.size.values #=> { small: 1, medium: 2, large: 3 }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nowlinuxing/minenum.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
