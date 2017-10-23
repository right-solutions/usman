# Usman

Simple User & Feature Permission Management with APIs.

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

# Usage

## Installing the kuppayam & usman migrations

Usman uses kuppayam skins and hence it requires the basic migrations from kuppayam to run
Run the below command to copy the migrations from the kuppayam engine.

```bash
$ bundle exec rake railties:install:migrations
```

This will copy migrations from kuppayam and usman engines which will have migrations to create images, documents, users, features and permissions respectively. 


## Mount the engine

Mount usman engine in your application routes.rb

```
mount Usman::Engine => "/"
```

open browser and go to /sign_in url

## Railties order

Specify the railties order if required in main application.rb

```bash
config.autoload_paths << "app/services"
config.railties_order = [:main_app, Usman::Engine, Kuppayam::Engine, :all]
```

# Seeding / Importing Data 

run rake task for loading dummy data for users and features to start with.

```bash
$ bundle exec rake usman:import:dummy:all verbose=false
```

["users", "features", "permissions", "roles"]

You could also do it individually but the above command will run in the following order - users, features, permissions, roles. This order is important as features need users to be imported first.

```bash
$ bundle exec rake usman:import:dummy:users verbose=false
$ bundle exec rake usman:import:dummy:features verbose=false
$ bundle exec rake usman:import:dummy:permissions verbose=false
$ bundle exec rake usman:import:dummy:roles verbose=false
```

## Cusotmized Importing

You could override the seed files with your data.
just create db/import_data in your project folder and create the following files filled with your data in the required format (checkout the dummy csvs in usman db/import_data/dummy/features.csv) for the columns required

for e.g:

create users.csv in db/import_data/ foler and fill data in it and run 

```bash
$ bundle exec rake usman:import:users verbose=false
```

## Testing the gem

cd spec/dummy
rails db:create db:migrate

rails s -p <port>

## Running rspec
rails db:create db:migrate RAILS_ENV

# run rspec from the rails root folder and not from dummy folder as spec helper has been linked to dummy.
rspec 


## Contributing

Visit - https://github.com/right-solutions/usman
Feel free to submit a patch 

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


