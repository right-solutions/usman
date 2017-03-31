# Usman
Simple User & Feature Permission Management

## Usage
Usman is a mountable plugin and it requires another full pluggin named kuppayam to run. Kuppayam offers usman the UI skin with basic modules for running like Polymorphic Image and Document Models etc.

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

# Installation Instructions

## Copy the migrations

Copy the migrations from the engines you are using
Run the below command 

```bash
$ bundle exec rake railties:install:migrations
```

This will copy migrations from kuppayam and usman engines
which will have migrations to create images, documents, users, features and permissions respectively. 

## Create Dummy Data 

run rake task for loading dummy data for users and features to start with.

## Mount the engine

Mount usman engine in your application routes.rb

```
mount Usman::Engine => "/"
```

open browser and go to /sign_in url




```bash
$ bundle exec rake usman:import:dummy:all verbose=false
```



## Specify the railties order if required

in main application.rb

```
config.autoload_paths << "app/services"
config.railties_order = [:main_app, Usman::Engine, Kuppayam::Engine, :all]
```


## Contributing

Visit - https://github.com/right-solutions/usman
Feel free to submit a patch 

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


