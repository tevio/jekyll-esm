# Jekyll::Esm

This plugin will allow you to define esm module definitions directly in your markup that point to local node_modules, then jekyll will handle installing and removing them automatically so that you can use local modules rather than cdn hosted ones.

## Why?

Looks like some of the major frameworks are moving away from asset bundlers as es6 is now able to do most of it internally, which is great. Now you can simply declare your esm definitions in the markup of your templates and with this plugin Jekyll will manage the installation behind the scenes with yarn (will make the package manager configurable in a later version).


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jekyll-esm'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install jekyll-esm

And add the following to your site's `_config.yml`

```yml
plugins:
  - jekyll/esm
```

NOTE the `/` - the `-` variant is not available yet.

ALSO NOTE - it's probably advisable to place this plugin as the very last one in the build pipe. EG:-

```yml
plugins:
  - jekyll-otherplug
  ...
  - jekyll/esm
```

### Example `_config.yml`
You can have a look at the possible configuration options in the fixtures config file at `spec/fixtures/_config.yml` in this repo.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then `cd spec/fixtures && yarn` to install required JS dependencies for specs. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tevio/jekyll-esm. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/tevio/jekyll-esm/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jekyll::Esm project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/jekyll-esm/blob/master/CODE_OF_CONDUCT.md).
