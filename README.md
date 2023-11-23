# Jekyll::Esm

This plugin will allow you to define esm module definitions directly in your markup that point to local node_modules, then jekyll will handle installing and removing them automatically so that you can use local modules rather than cdn hosted ones.

## Why?

Looks like some of the major frameworks are moving away from asset bundlers as es6 is now able to do most of it internally, which is great. Now you can simply declare your esm definitions in the markup of your templates and with this plugin Jekyll will manage the installation behind the scenes with yarn by default, but you can additionally specify npm or bower as the package manager.


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
  - jekyll-esm
```

## Select a package manager
jekyll-esm uses yarn by default but if you prefer npm or bower, its:

``` yml
# _config.yml

esm:
  manager: npm|bower
```

# Destination folder
Additionally you can rename the destination folder for production, so where by default it would output to _\_site/node_packages_ or _\_site/bower_components_, if you set the `dist`:

_A NOTE ON NPM_ if you don't have a _package.json_ file in your root, npm will actually search in the parent folder for a _package.json_.


``` yml
# _config.yml

esm:
  dist: dist
```

Then all your managed packages will be available at `_site/dist`.

# Ignore package.json!
Currently You *MUST* exclude package.json in the `_config.yml` otherwise jekyll will go into a loop. Sucks a bit but will try and improve that.

```yml
exclude:
  - package.json
```

## Optimizing
### Strict mode
You can run in strict mode to increase logging verbosity from the js package manager.

``` yml
# _config.yml

esm:
  strict: true
```

### data-esm-id attribute
You can set this on a declaration to prevent Jekyll from processing it more than once (eg, if you have lots of compiled pages, with the same layout, you don't want to run it more than once per importmap declaration):-

``` html
    <script data-esm-id='1' type="importmap">
      {
        "imports": {
          "/src/index.js": "/src/index.js"
        }
      }
    </script>
```

If you have multiple importmap declarations with different values, set a different id for each one, or no id at all, but no id is less speed efficient, as jekyll will process them each time for every page.

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
