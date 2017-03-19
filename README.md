# Usman
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'usman'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install usman
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

# Installation Instructions

# in main application.rb

config.autoload_paths << "app/services"
config.railties_order = [:main_app, Usman::Engine, Kuppayam::Engine, :all]

# add config/initializers/uptime.rb
Dummy::BOOTED_AT = Time.now
