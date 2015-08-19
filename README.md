# Geotab

TODO: Write a gem description

Ruby wrapper for the Geotab SDK API inspired by ActiveRecord.

Add this line to your application's Gemfile:

```ruby
gem 'geotab'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install geotab

## Usage
Global connection configuration

```Geotab.config do |c|
  c.username = "<username>"
  c.password = "<password>"
  c.database = "<database>"
  c.path = "myxx.geotab.com"
end

Geotab::Device.all
```

Or inline connection

```client = Geotab::Client.new
client.authenticate("<username>", "<password>", "<database>")

Geotab::Device.with_connection(client).all
```

Geotab resources are modeled after ActiveRecord models. They have access to `.all`, `.where`, `.find`, and `.first`. The `where` mehtod is chainable.

```# Returns an array of devices
Geotab::Device.all

# Returns a single device
Geotab::Device.first
Geotab::Device.find("b1")

# Where clauses are chainable. Conditions should follow Geotab SDK syntax
Geotab::Device.where({"serialNumber" => "G7B020D3E1A4"}).where({"name" => "07 BMW 335i"}).first
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/geotab/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
