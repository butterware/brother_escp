[![Build Status](https://travis-ci.org/butterware/brother_escp.svg?branch=master)](https://travis-ci.org/butterware/brother_escp)
[![Gem Version](https://badge.fury.io/rb/brother_escp.svg)](https://badge.fury.io/rb/brother_escp)

# BrotherEscp

*WORK IN PROGRESS*

Library to allow printing on Brother label printer, tested with TD-4000 model.

Allow printing of text and images.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'brother_escp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install brother_escp

## Usage

```
  
  require 'brother_escp'

  # Create a new document to send to the printer
  doc = BrotherEscp::Document.new

  # Use predefined sequences
  doc.sequence :LANDSCAPE_OFF
  
  # Use helper to setup some printing settings
  doc.page_length = 50

  # Print some text
  doc.write "Hello, world"

  # Add an image
  doc.image(file_name: 'examples/small.png', density: :high_density)

  # Add a form feed
  doc.sequence(:CTL_FF)

  # Raw data to be sent to the printer
  doc.to_escp

  # Dump the data in readable hexadecimal form
  doc.inspect
  
  # Raw data encoded in Base64
  doc.to_base64

```

## Documentation

Generate the documentation with yard

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/brother_escp. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
